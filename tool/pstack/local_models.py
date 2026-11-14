"""pstack のモデルの割り当てを、git 管理外のファイルで上書きする。

実体は git の共通ディレクトリ（すべての worktree が共有する .git）に 1 つだけ置く。
Claude Code は SessionStart のフック（.claude/settings.json）が `show` の出力を毎回読み込む。
"""
from pathlib import Path
import re
import subprocess

NAME = 'pstack-models.local.md'
KEY = re.compile(r'[a-z][a-z0-9 ,.-]*')
TEMPLATE = """\
# pstack のモデルのローカル上書き。git 管理外で、すべての worktree が共有する。
# 書いた行だけが .claude/rules/pstack-models.md の同じ名前の行を置き換える。会話中の利用者の指示はこのファイルより優先する。
# provider: thread（スレッドを始めたモデルの provider）、claude、codex のいずれか。
# cross-provider: on のときだけ、パネルともう一方の provider への委譲を使う。
# 変更は `python3 tool/pstack/pstack.py models set <名前> <値>` か、このファイルを直接直す。
provider: thread
cross-provider: off
ui: claude:sonnet medium (settled spec), claude:fable low (open look)
"""
HEADER = ('# Local model override (git-ignored, shared by every worktree): {path}\n'
          '# Lines here replace the lines with the same name in .claude/rules/pstack-models.md.\n')


def _git(checkout, *args):
    return subprocess.run(['git', '-C', str(checkout), *args], check=True,
                          capture_output=True, text=True).stdout.strip()


def common_file(checkout):
    common = _git(checkout, 'rev-parse', '--path-format=absolute', '--git-common-dir')
    return Path(common) / NAME


def ensure(target):
    """実体が無ければ雛形で作る。"""
    if not target.exists():
        target.write_text(TEMPLATE, encoding='utf-8')
    return target


def show(checkout, target=None):
    """セッションの文脈に入れる本文を返す。"""
    target = ensure(Path(target) if target else common_file(Path(checkout)))
    return HEADER.format(path=target) + target.read_text(encoding='utf-8')


def set_value(checkout, key, value, target=None):
    """`<key>: <value>` の行を置き換え、無ければ末尾に足す。"""
    key, value = key.strip(), ' '.join(value.split())
    if not KEY.fullmatch(key) or not value:
        raise ValueError('Use a role or setting name such as "ui" or "cross-provider", and a value')
    target = ensure(Path(target) if target else common_file(Path(checkout)))
    lines = target.read_text(encoding='utf-8').splitlines()
    line = f'{key}: {value}'
    for index, current in enumerate(lines):
        if not current.startswith('#') and current.split(':', 1)[0].strip() == key:
            lines[index] = line
            break
    else:
        lines.append(line)
    target.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    return dict(target=str(target), line=line)
