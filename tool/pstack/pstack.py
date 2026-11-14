"""公式 pstack の固定版を、Skill としてリポジトリへ取り込み、照合する。

manifest.json の install が上流のパスと取り込み先を対応させる。
overlays に指定したファイルは、上流の本文の後ろにプロジェクトの上書きを足して書く。
status は取り込み済みのファイルから上書きを外し、上流の SHA256 と照合する。
models は git 管理外のモデルの上書き（local_models.py）を表示し、値を書き換える。
"""
import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import ssl
import subprocess
import sys
import tempfile
import urllib.request
from urllib.error import URLError

if __package__:
    from . import local_models
else:  # python3 tool/pstack/pstack.py として直接動かすとき
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import local_models

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[1]
MAX_BYTES = 2 * 1024 * 1024
PIN = re.compile('[0-9a-f]{40}')


def _safe(name):
    path = PurePosixPath(name)
    return not path.is_absolute() and '..' not in path.parts and name.strip() == name and name


def manifest(path=None):
    data = json.loads((path or ROOT / 'manifest.json').read_text(encoding='utf-8'))
    if not isinstance(data, dict) or not isinstance(data.get('pin'), str) or not PIN.fullmatch(data['pin']):
        raise ValueError('Invalid pinned manifest')
    for key in ('install', 'overlays', 'files'):
        if not isinstance(data.get(key), dict):
            raise ValueError(f'Manifest needs a {key} object')
    if not isinstance(data.get('exclude', []), list):
        raise ValueError('exclude must be a list')
    if data['install'].get('pstack/LICENSE') is None:
        raise ValueError('The MIT license must be installed')
    for source, target in data['install'].items():
        if not (_safe(source) and _safe(target)) or source.endswith('/') != target.endswith('/'):
            raise ValueError('Unsafe install mapping: ' + source)
    for name, overlay in data['overlays'].items():
        if not (_safe(name) and _safe(overlay)) or name.endswith('/'):
            raise ValueError('Unsafe overlay: ' + name)
    for name, digest in data['files'].items():
        if not _safe(name) or not isinstance(digest, str) or not re.fullmatch('[0-9a-f]{64}', digest):
            raise ValueError('Invalid file entry: ' + name)
        target_of(data, name)
    return data


def managed(data, name):
    if any(name.startswith(prefix) for prefix in data.get('exclude', [])):
        return False
    return any(name == s or s.endswith('/') and name.startswith(s) for s in data['install'])


def target_of(data, name):
    matches = [s for s in data['install'] if name == s or s.endswith('/') and name.startswith(s)]
    if not matches or not managed(data, name):
        raise ValueError('Not an installed upstream path: ' + name)
    source = max(matches, key=len)
    target = REPO / (data['install'][source] + name[len(source):])
    if not target.resolve().is_relative_to(REPO.resolve()):
        raise ValueError('Install target escapes the repository: ' + name)
    for part in [target, *target.parents]:
        if part == REPO:
            break
        if part.is_symlink():
            raise ValueError('Install targets must not pass through links: ' + name)
    return target


def _marker(overlay):
    return f'\n<!-- pstack project overlay: {overlay} -->\n'.encode()


def compose(data, name, upstream):
    overlay = data['overlays'].get(name)
    if overlay is None:
        return upstream
    return upstream + _marker(overlay) + (REPO / overlay).read_bytes()


def upstream_part(data, name, installed):
    overlay = data['overlays'].get(name)
    if overlay is None:
        return installed
    suffix = _marker(overlay) + (REPO / overlay).read_bytes()
    return installed[:-len(suffix)] if installed.endswith(suffix) else None


def _context():
    # macOS の Python に CA が無ければ OS の証明書を使い、TLS の検証を保つ。
    context = ssl.create_default_context()
    if not os.environ.get('SSL_CERT_FILE') and Path('/etc/ssl/cert.pem').is_file():
        context.load_verify_locations('/etc/ssl/cert.pem')
    return context


def _get(url):
    with urllib.request.urlopen(url, timeout=30, context=_context()) as response:
        body = response.read(MAX_BYTES + 1)
    if len(body) > MAX_BYTES:
        raise ValueError('Upstream file is too large: ' + url)
    return body


def fetch(pin, name):
    return _get(f'https://raw.githubusercontent.com/cursor/plugins/{pin}/{name}')


def upstream_tree(pin):
    body = _get(f'https://api.github.com/repos/cursor/plugins/git/trees/{pin}?recursive=1')
    tree = json.loads(body)
    if tree.get('truncated'):
        raise ValueError('Upstream tree listing is truncated')
    return [item['path'] for item in tree['tree'] if item['type'] == 'blob']


def _write(target, body):
    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=target.parent, delete=False) as stream:
        temporary = Path(stream.name)
        try:
            stream.write(body)
            stream.close()
            temporary.replace(target)
        finally:
            temporary.unlink(missing_ok=True)


def _stale(data):
    expected = {target_of(data, name) for name in data['files']}
    stale = []
    for source, target in data['install'].items():
        if not target.endswith('/'):
            continue
        directory = REPO / target
        if directory.is_dir():
            stale += [p for p in directory.rglob('*') if p.is_file() and p not in expected
                      and '__pycache__' not in p.parts]
    return sorted(stale)


def status(data=None):
    data = data or manifest()
    invalid = []
    for name, digest in data['files'].items():
        target = target_of(data, name)
        part = upstream_part(data, name, target.read_bytes()) if target.is_file() else None
        if part is None or hashlib.sha256(part).hexdigest() != digest:
            invalid.append(name)
    stale = [str(p.relative_to(REPO)) for p in _stale(data)]
    return dict(pin=data['pin'], files=len(data['files']), valid=not invalid and not stale,
                invalid=invalid, stale=stale)


def sync():
    data = manifest()
    writes = []
    for name in status(data)['invalid']:
        body = fetch(data['pin'], name)
        if hashlib.sha256(body).hexdigest() != data['files'][name]:
            raise ValueError('Checksum mismatch: ' + name)
        writes.append((target_of(data, name), compose(data, name, body)))
    for target, body in writes:
        _write(target, body)
    for path in _stale(data):
        path.unlink()
    return status(data)


def propose_update(pin, output):
    if not PIN.fullmatch(pin):
        raise ValueError('Use a full commit SHA, not a branch or tag')
    current = manifest()
    names = sorted(name for name in upstream_tree(pin) if managed(current, name))
    candidate = dict(current, pin=pin, files={
        name: hashlib.sha256(fetch(pin, name)).hexdigest() for name in names})
    with output.open('x', encoding='utf-8') as stream:
        stream.write(json.dumps(candidate, indent=2) + '\n')
    added = sorted(set(names) - set(current['files']))
    removed = sorted(set(current['files']) - set(names))
    changed = sorted(n for n in names if n in current['files'] and current['files'][n] != candidate['files'][n])
    return dict(candidate=str(output), pin=pin, added=added, removed=removed, changed=changed,
                review_required=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    commands.add_parser('sync', help='Fetch pinned files that are missing or modified, then remove stale ones')
    commands.add_parser('status', help='Check installed files against the pinned SHA256 values')
    update = commands.add_parser('propose-update', help='Write a candidate manifest for another commit')
    update.add_argument('--pin', required=True)
    update.add_argument('--output', required=True, type=Path)
    models = commands.add_parser('models', help='Manage the git-ignored model override shared by all worktrees')
    actions = models.add_subparsers(dest='action', required=True)
    actions.add_parser('show', help='Print the shared override, creating it from the template if missing')
    actions.add_parser('path', help='Print the path of the shared override')
    setter = actions.add_parser('set', help='Replace or add one "<name>: <value>" line in the shared override')
    setter.add_argument('key')
    setter.add_argument('value', nargs='+')
    args = parser.parse_args()
    try:
        if args.command == 'models':
            if args.action == 'show':
                print(local_models.show(Path.cwd()), end='')
            elif args.action == 'path':
                print(local_models.ensure(local_models.common_file(Path.cwd())))
            else:
                result = local_models.set_value(Path.cwd(), args.key, ' '.join(args.value))
                print(json.dumps(result, indent=2, ensure_ascii=False))
            return 0
        if args.command == 'propose-update':
            print(json.dumps(propose_update(args.pin, args.output), indent=2))
            return 0
        result = sync() if args.command == 'sync' else status()
    except (ValueError, OSError, URLError, subprocess.CalledProcessError) as error:
        parser.error(str(error))
    print(json.dumps(result, indent=2))
    return int(not result['valid'])


if __name__ == '__main__':
    raise SystemExit(main())
