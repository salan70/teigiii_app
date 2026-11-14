#!/usr/bin/env python3
"""画面と Ds コンポーネントの各状態を撮り、UI レビュー用のギャラリーを作る（Issue #339）。

使い方（リポジトリルートで。通常は just ui-review 経由）:
  just ui-review list
  just ui-review capture --all
  just ui-review capture --only screen.home,component.ds_chip
  just ui-review gallery
  just ui-review serve
  just deploy-ui-review

手順書: doc/guides/ui-review.md
"""

import argparse
import datetime
import functools
import html
import http.server
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path

TOOL_DIR = Path(__file__).resolve().parent
MOBILE_DIR = TOOL_DIR.parents[1]
REPO = TOOL_DIR.parents[2]
TARGETS_JSON = TOOL_DIR / "targets.json"
CAPTURE_TEST = "tool/ui_review/capture_test.dart"
DEFAULT_OUT = REPO / "artifacts" / "ui-review"
WIDGETBOOK_DIR = "widgetbook"
KIND_LABEL = {"screen": "画面", "component": "コンポーネント"}
STATUS_LABEL = {"ok": "撮影済み", "failed": "失敗", "missing": "未登録"}


# ---------------------------------------------------------------- 登録表


def load_targets():
    return json.loads(TARGETS_JSON.read_text(encoding="utf-8"))


def target_by_id(registry):
    return {t["id"]: t for t in registry["targets"]}


def state_variants(registry, state):
    """状態を撮るバリアント ID。状態が指定しなければ全バリアント。"""
    return state.get("variants") or [v["id"] for v in registry["variants"]]


def cmd_list(args):
    registry = load_targets()
    rows = [("対象", "状態")]
    for target in registry["targets"]:
        rows.append((target["id"], ", ".join(s["id"] for s in target["states"])))
    width = max(len(row[0]) for row in rows)
    for left, right in rows:
        print(f"{left.ljust(width)}  {right}")
    states = sum(len(t["states"]) for t in registry["targets"])
    images = sum(len(state_variants(registry, s)) for t in registry["targets"] for s in t["states"])
    print(f"\n{len(registry['targets'])} 対象 / {states} 状態 / {images} 枚")
    print(f"撮らない対象 {len(registry.get('excluded', []))} 件:")
    for item in registry.get("excluded", []):
        print(f"  {item['id']}: {item['reason']}")
    return 0


# ---------------------------------------------------------------- 撮影


def git(*args):
    try:
        result = subprocess.run(["git", "-C", str(REPO), *args], capture_output=True, text=True)
    except FileNotFoundError:
        return ""
    return result.stdout.strip() if result.returncode == 0 else ""


def git_info():
    return {
        "branch": git("rev-parse", "--abbrev-ref", "HEAD") or "unknown",
        "head": git("rev-parse", "--short", "HEAD") or "unknown",
        "dirty": bool(git("status", "--porcelain")),
    }


def entry_key(entry):
    return (entry["id"], entry["state"], entry["variant"])


def merge_entries(previous, fresh, selected_ids, valid_ids):
    """前回の結果に今回の結果を重ねる。今回撮った対象は前回分を捨て、対象表から消えた対象も捨てる。"""
    kept = [e for e in previous if e["id"] in valid_ids and e["id"] not in selected_ids]
    return kept + fresh


def clean_targets(out, ids):
    for target_id in ids:
        shutil.rmtree(out / target_id, ignore_errors=True)


def cmd_capture(args):
    registry = load_targets()
    known = target_by_id(registry)
    if args.all:
        selected = list(known)
    elif args.only:
        selected = [part for part in args.only.split(",") if part]
        unknown = [i for i in selected if i not in known]
        if unknown:
            print(f"対象表にない ID: {', '.join(unknown)}（just ui-review list で確認する）", file=sys.stderr)
            return 2
    else:
        print("--all か --only <ID> を指定する", file=sys.stderr)
        return 2

    out = Path(args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)
    clean_targets(out, selected)
    results_path = out / "results.json"
    results_path.unlink(missing_ok=True)

    only = "" if args.all else ",".join(selected)
    command = [
        "flutter",
        "test",
        CAPTURE_TEST,
        f"--dart-define=UI_REVIEW_OUT={out}",
        f"--dart-define=UI_REVIEW_ONLY={only}",
    ]
    try:
        code = subprocess.run(command, cwd=MOBILE_DIR).returncode
    except FileNotFoundError:
        print("flutter が PATH にない（nix develop の中で実行する）", file=sys.stderr)
        return 2
    if not results_path.exists():
        print(f"撮影の結果（{results_path}）が出ていない。flutter test が失敗した（exit {code}）", file=sys.stderr)
        return 1
    fresh = json.loads(results_path.read_text(encoding="utf-8"))
    results_path.unlink()

    manifest_path = out / "manifest.json"
    previous = []
    if manifest_path.exists():
        previous = json.loads(manifest_path.read_text(encoding="utf-8")).get("entries", [])
    manifest = {
        "generatedAt": datetime.datetime.now().astimezone().isoformat(timespec="seconds"),
        "git": git_info(),
        "entries": merge_entries(previous, fresh, set(selected), set(known)),
    }
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding="utf-8")
    write_gallery(out, registry, manifest)

    counts = {s: sum(1 for e in fresh if e["status"] == s) for s in STATUS_LABEL}
    warned = sum(1 for e in fresh if e.get("warnings"))
    print(
        f"撮影: ok {counts['ok']} / failed {counts['failed']} / 未登録 {counts['missing']}"
        f" · 警告あり {warned} 枚 · {out / 'index.html'}"
    )
    for e in fresh:
        if e["status"] != "ok":
            print(f"  {STATUS_LABEL[e['status']]}: {e['id']} / {e['state']} / {e['variant']}: {e.get('reason', '')}")
    # 撮り漏れ（登録表にあるのに結果がない状態）は、全件撮影のときだけ数える。
    if args.all:
        got = {(e["id"], e["state"], e["variant"]) for e in fresh}
        absent = [
            (t["id"], s["id"], v)
            for t in registry["targets"]
            for s in t["states"]
            for v in state_variants(registry, s)
            if (t["id"], s["id"], v) not in got
        ]
        if absent:
            print(f"撮影されなかった {len(absent)} 枚（flutter test が途中で止まった可能性）", file=sys.stderr)
            return 1
    return 0 if counts["failed"] == 0 and counts["missing"] == 0 else 1


# ---------------------------------------------------------------- ギャラリー

CSS = """
:root{color-scheme:light dark;--bg:#fafafa;--fg:#1c1c1e;--muted:#6b6b70;--line:#d9d9de;--card:#fff;--accent:#0a8f7c;--warn:#b45309;--bad:#c0262d}
@media (prefers-color-scheme:dark){:root{--bg:#161618;--fg:#f2f2f4;--muted:#9a9aa1;--line:#34343a;--card:#202024;--accent:#3ec7b0;--warn:#f0a24b;--bad:#ff7b7f}}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);font:14px/1.6 system-ui,-apple-system,"Hiragino Sans",sans-serif}
a{color:var(--accent)}
header,main,.filters,details,.summary{max-width:1200px;margin:0 auto;padding:0 16px}
header{padding-top:20px}
h1{font-size:20px;margin:0 0 4px}
.meta{color:var(--muted);font-size:12px}
.filters{display:flex;flex-wrap:wrap;gap:8px;margin-top:12px;margin-bottom:8px}
.filters select,.filters input[type=search]{font:inherit;padding:6px 8px;border:1px solid var(--line);border-radius:6px;background:var(--card);color:var(--fg)}
.filters label{display:flex;align-items:center;gap:4px}
.summary{color:var(--muted);margin-bottom:8px}
.target{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:12px;margin:12px 0}
.target h2{font-size:15px;margin:0}
.target h2 a{color:inherit;text-decoration:none}
.target .sub{color:var(--muted);font-size:12px}
.thumbs{display:flex;gap:10px;overflow-x:auto;padding:8px 0 2px}
.thumb{flex:0 0 auto;width:140px;text-decoration:none;color:inherit}
.thumb img{display:block;width:140px;height:auto;border:1px solid var(--line);border-radius:6px;background:#fff}
.thumb .cap{font-size:11px;color:var(--muted);margin-top:2px}
.badge{display:inline-block;font-size:11px;padding:0 6px;border-radius:8px;border:1px solid var(--line);color:var(--muted);margin-left:4px}
.badge.warn{color:var(--warn);border-color:var(--warn)}
.badge.failed,.badge.missing{color:var(--bad);border-color:var(--bad)}
.state{margin:16px 0}
.state h3{font-size:14px;margin:0 0 6px}
.pair{display:flex;gap:12px;flex-wrap:wrap;align-items:flex-start}
.shot{margin:0}
.shot img{display:block;max-width:100%;height:auto;border:1px solid var(--line);border-radius:6px;background:#fff}
.shot.main img{width:300px}
.shot.extra img{width:220px}
.shot figcaption{font-size:11px;color:var(--muted);margin-top:2px}
.warning{color:var(--warn);font-size:12px}
.reason{color:var(--bad);font-size:12px}
.excluded li{margin:4px 0}
nav{max-width:1200px;margin:0 auto;padding:12px 16px 0}
@media (max-width:600px){.shot.main img{width:100%}}
"""

JS = """
const q=document.getElementById('q'),kind=document.getElementById('f-kind'),state=document.getElementById('f-state'),warn=document.getElementById('f-warn');
const shown=document.getElementById('shown');
function apply(){
  const text=q.value.trim().toLowerCase();let n=0;
  document.querySelectorAll('.target').forEach(t=>{
    let any=false;
    t.querySelectorAll('.thumb').forEach(th=>{
      const ok=(!state.value||th.dataset.state===state.value)&&(!warn.checked||th.dataset.warn==='1');
      th.hidden=!ok;if(ok)any=true;
    });
    const ok=any&&(!kind.value||t.dataset.kind===kind.value)&&(!text||t.dataset.search.includes(text));
    t.hidden=!ok;if(ok)n++;
  });
  shown.textContent=n;
}
[q,kind,state,warn].forEach(e=>e.addEventListener('input',apply));apply();
"""


def png_size(path):
    if not path.exists():
        return None
    with path.open("rb") as f:
        head = f.read(24)
    if len(head) < 24 or head[:8] != b"\x89PNG\r\n\x1a\n" or head[12:16] != b"IHDR":
        return None
    return struct.unpack(">II", head[16:24])


def esc(value):
    return html.escape(str(value), quote=True)


def entries_by_target(manifest):
    grouped = {}
    for e in manifest["entries"]:
        grouped.setdefault(e["id"], {}).setdefault(e["state"], {})[e["variant"]] = e
    return grouped


def img_tag(out, entry, label):
    size = png_size(out / entry["file"])
    dims = f' width="{size[0] // 2}" height="{size[1] // 2}"' if size else ""
    return f'<img loading="lazy" src="{esc(entry["file"])}" alt="{esc(label)}"{dims}>'


def page(title, body):
    return (
        '<!doctype html>\n<html lang="ja"><head><meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1">'
        f"<title>{esc(title)}</title><style>{CSS}</style></head><body>{body}</body></html>\n"
    )


def write_target_page(out, registry, target, states_by_variant, manifest):
    """対象ごとの固定 URL（`/<対象 ID>/`）。状態ごとにライトとダークを並べ、他のバリアントを続ける。"""
    variants = {v["id"]: v for v in registry["variants"]}
    sections = []
    for state in target["states"]:
        per_variant = states_by_variant.get(state["id"], {})
        shots = []
        notes = []
        for variant_id in state_variants(registry, state):
            e = per_variant.get(variant_id)
            if e is None:
                continue
            label = f"{target['title']} {state['title']} {variants[variant_id]['label']}"
            main = variant_id in ("light", "dark")
            if e["status"] == "ok":
                shots.append(
                    f'<figure class="shot {"main" if main else "extra"}">'
                    f'<a href="{esc(Path(e["file"]).name)}">{img_tag(out, {**e, "file": Path(e["file"]).name}, label)}</a>'
                    f"<figcaption>{esc(variants[variant_id]['label'])}</figcaption></figure>"
                )
            else:
                notes.append(
                    f'<div class="reason">{esc(variants[variant_id]["label"])}: {esc(STATUS_LABEL[e["status"]])} {esc(e.get("reason", ""))}</div>'
                )
            for w in e.get("warnings", []):
                notes.append(f'<div class="warning">⚠ {esc(variants[variant_id]["label"])}: {esc(w)}</div>')
        sections.append(
            f'<section class="state" id="{esc(state["id"])}"><h3>{esc(state["title"])} '
            f'<span class="badge">{esc(state["id"])}</span></h3><div class="pair">{"".join(shots)}</div>{"".join(notes)}</section>'
        )
    body = (
        f'<nav><a href="../index.html">← 一覧</a></nav>'
        f'<header><h1>{esc(target["title"])} <span class="badge">{esc(KIND_LABEL[target["kind"]])}</span></h1>'
        f'<div class="meta">{esc(target["id"])} · {esc(target["description"])}</div>'
        f'<div class="meta">{esc(target["source"])}</div></header><main>{"".join(sections)}</main>'
    )
    target_dir = out / target["id"]
    target_dir.mkdir(parents=True, exist_ok=True)
    (target_dir / "index.html").write_text(page(f"{target['title']} - UI 確認", body), encoding="utf-8")


def write_gallery(out, registry, manifest):
    grouped = entries_by_target(manifest)
    state_ids = []
    for t in registry["targets"]:
        for s in t["states"]:
            if s["id"] not in state_ids:
                state_ids.append(s["id"])
    cards = []
    total_warn = 0
    for target in registry["targets"]:
        states_by_variant = grouped.get(target["id"], {})
        if not states_by_variant:
            continue
        write_target_page(out, registry, target, states_by_variant, manifest)
        thumbs = []
        for state in target["states"]:
            per_variant = states_by_variant.get(state["id"], {})
            e = per_variant.get("light") or next(iter(per_variant.values()), None)
            if e is None:
                continue
            warned = any(v.get("warnings") for v in per_variant.values())
            total_warn += 1 if warned else 0
            bad = any(v["status"] != "ok" for v in per_variant.values())
            image = (
                img_tag(out, e, f"{target['title']} {state['title']}")
                if e["status"] == "ok"
                else f'<div class="reason">{esc(STATUS_LABEL[e["status"]])}</div>'
            )
            badge = (' <span class="badge warn">警告</span>' if warned else "") + (
                ' <span class="badge failed">失敗</span>' if bad else ""
            )
            thumbs.append(
                f'<a class="thumb" href="{esc(target["id"])}/#{esc(state["id"])}" data-state="{esc(state["id"])}" '
                f'data-warn="{1 if warned else 0}">{image}<div class="cap">{esc(state["title"])}{badge}</div></a>'
            )
        search = f"{target['id']} {target['title']} {target['description']}".lower()
        cards.append(
            f'<article class="target" data-kind="{esc(target["kind"])}" data-search="{esc(search)}">'
            f'<h2><a href="{esc(target["id"])}/">{esc(target["title"])}</a> '
            f'<span class="badge">{esc(KIND_LABEL[target["kind"]])}</span></h2>'
            f'<div class="sub">{esc(target["id"])} · {esc(target["description"])}</div>'
            f'<div class="thumbs">{"".join(thumbs)}</div></article>'
        )

    state_options = "".join(f'<option value="{esc(s)}">{esc(s)}</option>' for s in state_ids)
    excluded = "".join(
        f"<li><code>{esc(i['id'])}</code>: {esc(i['reason'])}</li>" for i in registry.get("excluded", [])
    )
    widgetbook = (
        '<nav><a href="widgetbook/">Widgetbook（操作して確かめる）</a></nav>'
        if (out / WIDGETBOOK_DIR / "index.html").exists()
        else ""
    )
    g = manifest["git"]
    body = (
        f"{widgetbook}<header><h1>teigiii UI 確認カタログ</h1>"
        f'<div class="meta">生成 {esc(manifest["generatedAt"])} · {esc(g["branch"])} @ {esc(g["head"])}'
        f'{" (dirty)" if g["dirty"] else ""}</div>'
        '<div class="meta">撮影条件: ロケール ja / 実フォント / ライト・ダーク / 幅 390・360 / 文字 1.5 倍</div></header>'
        '<div class="filters"><input id="q" type="search" placeholder="対象を検索（ID・名前）" aria-label="対象を検索">'
        '<select id="f-kind" aria-label="種別"><option value="">種別: すべて</option>'
        '<option value="screen">画面</option><option value="component">コンポーネント</option></select>'
        f'<select id="f-state" aria-label="状態"><option value="">状態: すべて</option>{state_options}</select>'
        '<label><input id="f-warn" type="checkbox">警告ありだけ</label></div>'
        f'<div class="summary">表示 <span id="shown">0</span> / {len(cards)} 対象 · 警告あり {total_warn} 状態</div>'
        f"<main>{''.join(cards)}</main>"
        f'<details class="excluded"><summary>撮っていない対象 {len(registry.get("excluded", []))} 件と理由</summary>'
        f"<ul>{excluded}</ul></details>"
        f"<script>{JS}</script>"
    )
    (out / "index.html").write_text(page("teigiii UI 確認カタログ", body), encoding="utf-8")


def cmd_gallery(args):
    out = Path(args.out).resolve()
    manifest_path = out / "manifest.json"
    if not manifest_path.exists():
        print(f"{manifest_path} がない。先に capture を実行する", file=sys.stderr)
        return 1
    write_gallery(out, load_targets(), json.loads(manifest_path.read_text(encoding="utf-8")))
    print(f"生成: {out / 'index.html'}")
    return 0


def cmd_widgetbook(args):
    """Widgetbook の Web ビルドを出力先の `/widgetbook/` に置く。"""
    out = Path(args.out).resolve()
    target = out / WIDGETBOOK_DIR
    command = [
        "flutter",
        "build",
        "web",
        "-t",
        "widgetbook/main.dart",
        "--base-href",
        "/widgetbook/",
        "--output",
        str(target),
    ]
    try:
        code = subprocess.run(command, cwd=MOBILE_DIR).returncode
    except FileNotFoundError:
        print("flutter が PATH にない（nix develop の中で実行する）", file=sys.stderr)
        return 2
    if code == 0:
        # mobile_app/web の Pages 用 Basic 認証（_worker.js と _lib）は、この配信には要らない。
        (target / "_worker.js").unlink(missing_ok=True)
        shutil.rmtree(target / "_lib", ignore_errors=True)
    if code == 0 and (out / "manifest.json").exists():
        write_gallery(out, load_targets(), json.loads((out / "manifest.json").read_text(encoding="utf-8")))
    return code


def cmd_serve(args):
    out = Path(args.out).resolve()
    if not (out / "index.html").exists():
        print(f"{out / 'index.html'} がない。先に capture を実行する", file=sys.stderr)
        return 1
    handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(out))
    server = http.server.ThreadingHTTPServer((args.host, args.port), handler)
    print(f"http://{args.host}:{args.port}/ で配信中（Ctrl-C で止める）")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    return 0


# ---------------------------------------------------------------- 配信（Cloudflare）

CF_API = "https://api.cloudflare.com/client/v4"
KEYCHAIN_SERVICE = "cloudflare-ui-review"
WRANGLER_CONFIG = TOOL_DIR / "wrangler.jsonc"


def publish_hostname():
    """配信先のホスト名。確認するホスト名と配る先をそろえるため、wrangler.jsonc の route から読む。"""
    match = re.search(r'"pattern"\s*:\s*"([^"]+)"', WRANGLER_CONFIG.read_text(encoding="utf-8"))
    if not match:
        raise SystemExit(f"{WRANGLER_CONFIG} に route の pattern が無い")
    return match.group(1)


def keychain_token():
    """macOS のキーチェーンから API トークンを読む。無い・読めないときは None。"""
    try:
        result = subprocess.run(
            ["security", "find-generic-password", "-s", KEYCHAIN_SERVICE, "-w"],
            capture_output=True,
            text=True,
        )
    except FileNotFoundError:
        return None
    token = result.stdout.strip()
    return token if result.returncode == 0 and token else None


def cf_get(path, token):
    """Cloudflare API を GET して result を返す。失敗時は RuntimeError（トークンは含めない）。"""
    request = urllib.request.Request(CF_API + path, headers={"Authorization": f"Bearer {token}"})
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            body = json.load(response)
    except (urllib.error.URLError, json.JSONDecodeError) as error:
        raise RuntimeError(f"Cloudflare API {path} に失敗: {error}") from None
    if not body.get("success"):
        messages = [str(item.get("message", item)) for item in body.get("errors", [])]
        raise RuntimeError(f"Cloudflare API {path} が失敗: {'; '.join(messages) or '不明'}")
    return body["result"]


def resolve_account(token):
    """アカウントが 1 件ならその ID を返す。それ以外は None。"""
    accounts = cf_get("/accounts", token)
    return accounts[0]["id"] if len(accounts) == 1 else None


def covers(value, hostname):
    """Access のドメイン表記（host、host/*、https:// 付き）がホスト名を指すか。"""
    value = re.sub(r"^https?://", "", str(value).strip())
    return value in (hostname, f"{hostname}/*")


def app_hosts(app):
    hosts = [app.get("domain") or ""]
    hosts += app.get("self_hosted_domains") or []
    for destination in app.get("destinations") or []:
        hosts.append(destination.get("uri", "") if isinstance(destination, dict) else destination)
    return hosts


def has_allow_policy(account, app, token):
    policies = app.get("policies") or []
    if not any(isinstance(policy, dict) for policy in policies):
        policies = cf_get(f"/accounts/{account}/access/apps/{app['id']}/policies", token)
    return any(policy.get("decision") == "allow" for policy in policies)


def access_protects(account, hostname, token):
    """hostname を覆う Access アプリが、allow の policy を 1 つでも持つか。"""
    for app in cf_get(f"/accounts/{account}/access/apps", token):
        if any(covers(host, hostname) for host in app_hosts(app)) and has_allow_policy(account, app, token):
            return True
    return False


def wrangler_command():
    found = shutil.which("wrangler")
    if found:
        return [found]
    local = REPO / "backend" / "node_modules" / ".bin" / "wrangler"
    if local.exists():
        return [str(local)]
    bunx = shutil.which("bunx")
    return [bunx, "wrangler"] if bunx else None


def cmd_publish(args):
    out = Path(args.out).resolve()
    if not (out / "manifest.json").exists() or not (out / "index.html").exists():
        print(f"{out} に manifest.json と index.html がない。先に capture --all を実行する", file=sys.stderr)
        return 2
    wrangler = wrangler_command()
    if wrangler is None:
        print("wrangler が見つからない（PATH か backend/node_modules。just backend-setup で入る）", file=sys.stderr)
        return 2
    env = dict(os.environ)
    if not args.dry_run:
        # 本番へ配る前に、公開ホスト名に Access（allow の policy 付き）がかかっていることを確かめる。
        token = os.environ.get("CLOUDFLARE_API_TOKEN") or keychain_token()
        if not token:
            print(
                f"API トークンがない。CLOUDFLARE_API_TOKEN か キーチェーン（{KEYCHAIN_SERVICE}）に入れる。"
                "手順は doc/guides/ui-review.md",
                file=sys.stderr,
            )
            return 2
        try:
            account = os.environ.get("CLOUDFLARE_ACCOUNT_ID") or resolve_account(token)
            if not account:
                print("アカウントを 1 つに決められない。CLOUDFLARE_ACCOUNT_ID で指定する", file=sys.stderr)
                return 2
            protected = access_protects(account, publish_hostname(), token)
        except RuntimeError as error:
            print(f"Access の確認に失敗したので配らない: {error}", file=sys.stderr)
            return 1
        if not protected:
            print(
                f"{publish_hostname()} に Access がかかっていない（allow の policy が無い）ので配らない",
                file=sys.stderr,
            )
            return 1
        env.update({"CLOUDFLARE_API_TOKEN": token, "CLOUDFLARE_ACCOUNT_ID": account})
    command = [*wrangler, "deploy", "--config", str(WRANGLER_CONFIG)]
    if args.dry_run:
        command.append("--dry-run")
    code = subprocess.run(command, cwd=REPO, env=env).returncode
    if code == 0 and not args.dry_run:
        print(f"https://{publish_hostname()}/")
    return code


def main():
    parser = argparse.ArgumentParser(description="画面とコンポーネントの UI レビュー用カタログ")
    sub = parser.add_subparsers(dest="command", required=True)

    listing = sub.add_parser("list", help="対象と状態の一覧")
    listing.set_defaults(func=cmd_list)

    capture = sub.add_parser("capture", help="撮影してギャラリーを作る")
    capture.add_argument("--all", action="store_true", help="全対象を撮る")
    capture.add_argument("--only", help="撮る対象の ID（カンマ区切り）。他の対象の撮影結果は残す")
    capture.add_argument("--out", default=str(DEFAULT_OUT))
    capture.set_defaults(func=cmd_capture)

    gallery = sub.add_parser("gallery", help="manifest から index.html を作り直す")
    gallery.add_argument("--out", default=str(DEFAULT_OUT))
    gallery.set_defaults(func=cmd_gallery)

    widgetbook = sub.add_parser("widgetbook", help="Widgetbook の Web ビルドを /widgetbook/ に置く")
    widgetbook.add_argument("--out", default=str(DEFAULT_OUT))
    widgetbook.set_defaults(func=cmd_widgetbook)

    serve = sub.add_parser("serve", help="出力を HTTP で配信する")
    serve.add_argument("--out", default=str(DEFAULT_OUT))
    serve.add_argument("--host", default="127.0.0.1")
    serve.add_argument("--port", type=int, default=8343)
    serve.set_defaults(func=cmd_serve)

    publish = sub.add_parser("publish", help="Access の存在を確かめてから Cloudflare へ配る")
    publish.add_argument("--out", default=str(DEFAULT_OUT))
    publish.add_argument("--dry-run", action="store_true", help="wrangler deploy --dry-run で設定を確かめるだけ")
    publish.set_defaults(func=cmd_publish)

    args = parser.parse_args()
    sys.exit(args.func(args))


if __name__ == "__main__":
    main()
