#!/usr/bin/env python3
"""ローカル検証の入口。`just check` / `just check-changed` と lefthook の hook から呼ぶ。

出力は 1 手順につき 1 行の要約だけにする。全文はログファイルに書き、失敗時はパスと末尾を示す。
mobile / backend のどちらを検証するかは、CI と同じ `.github/changes-filter*.yml` から決める。
"""
import argparse
import os
from pathlib import Path
import posixpath
import re
import shutil
import subprocess
import sys
import time
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent.parent
FILTER = ROOT / ".github" / "changes-filter.yml"
FILTER_CODE = ROOT / ".github" / "changes-filter-code.yml"
DEFAULT_BASE = "origin/develop"
TAIL_LINES = 15
# 成功しても出力が報告そのものになる手順。justfile 側で `|| true` により常に成功するため、出力を捨てると報告が見えない。
REPORT_STEPS = {"docbridge-related-staged"}

# just のレシピ名。上から順に実行し、最初の失敗で止める。
DOCS_STEPS = ["docbridge-check"]
MOBILE_STEPS = ["mobile-format-check", "mobile-analyze", "mobile-ds-check", "mobile-test", "web-test"]
BACKEND_STEPS = ["backend-format-check", "backend-analyze", "backend-test-unit", "backend-test-workers"]

# Markdown のリンク検査から外す。取り込み物と生成物のリンクは直せないため。
MD_LINK_EXCLUDES = ("tool/pstack/upstream/", ".claude/skills/", "mobile_app/packages/teigiii_api/", "node_modules/")
DEBUG_CODE = re.compile(r"debugPrint\(|console\.(log|debug)|debugger|TODO: remove|FIXME: debug")
DEBUG_CODE_GLOBS = ("*.dart", "*.ts", "*.tsx", "*.js")


# --- 実行環境 ---


def tool_prefix() -> list[str]:
    """Nix の shell の外から呼ばれたときは `nix develop -c` を前置する。"""
    if os.environ.get("IN_NIX_SHELL"):
        return []
    if shutil.which("nix"):
        return ["nix", "develop", "-c"]
    if shutil.which("just"):
        return []
    sys.exit("just も nix も見つかりません。Nix を入れて direnv allow を実行してください。")


def log_dir() -> Path:
    # nix の shell は TMPDIR を終了時に消すため、一時ディレクトリには置かない。
    cache = Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache")
    path = cache / "teigiii-check" / time.strftime("%Y%m%d-%H%M%S")
    path.mkdir(parents=True, exist_ok=True)
    return path


def clean_env() -> dict[str, str]:
    """hook から呼ばれると git が GIT_DIR などを渡す。子プロセスの git が誤ったリポジトリを見ないよう外す。

    GIT_INDEX_FILE は残す。`git commit -a` や `commit <path>` では hook が一時 index を指しており、外すと本物の index を見てしまう。
    """
    drop = {"GIT_DIR", "GIT_WORK_TREE", "GIT_PREFIX"}
    env = {k: v for k, v in os.environ.items() if k not in drop}
    env["PWD"] = str(ROOT)  # subprocess の cwd は PWD を更新しない。nix が PWD を見て flake を探すため合わせる
    return env


def in_dir(prefix: list[str], subdir: str, cmd: list[str]) -> list[str]:
    """nix develop はリポジトリ直下で開き（shellHook の PUB_CACHE が PWD 基準のため）、その中で subdir へ移る。"""
    return [*prefix, "bash", "-c", 'cd "$0" && exec "$@"', subdir, *cmd]


def run_step(name: str, cmd: list[str], logs: Path) -> bool:
    """cmd をリポジトリ直下で実行して要約を 1 行で出す。全文は logs/<name>.log に書く。"""
    log = logs / f"{name}.log"
    started = time.monotonic()
    with log.open("w") as fh:
        result = subprocess.run(cmd, cwd=ROOT, env=clean_env(), stdout=fh, stderr=subprocess.STDOUT)
    seconds = time.monotonic() - started
    if result.returncode == 0:
        print(f"✓ {name} ({seconds:.0f}s)")
        if name in REPORT_STEPS:
            for line in log.read_text(errors="replace").splitlines():
                print(f"  | {line}")
        return True
    print(f"✗ {name} ({seconds:.0f}s) exit={result.returncode}\n  log: {log}")
    lines = log.read_text(errors="replace").splitlines()
    for line in lines[-TAIL_LINES:]:
        print(f"  | {line}")
    return False


def run_recipes(recipes: list[str]) -> int:
    logs = log_dir()
    prefix = tool_prefix()
    # 既知の失敗（macOS の backend-test-unit は #328）を外すための明示的な逃げ道。黙って外さず、skip を表示する。
    skipped = set(os.environ.get("TEIGIII_SKIP_STEPS", "").split())
    for recipe in recipes:
        if recipe in skipped:
            print(f"- {recipe}: skip（TEIGIII_SKIP_STEPS）")
            continue
        if not run_step(recipe, [*prefix, "just", recipe], logs):
            print(f"全文: rg -n '' {logs}/{recipe}.log")
            return 1
    print(f"ログ: {logs}")
    return 0


# --- 変更範囲（CI の changes ジョブと同じ規則） ---


def load_filters(path: Path) -> dict[str, list[str]]:
    """`name:` と `  - 'glob'` だけの平らな YAML を読む。"""
    filters: dict[str, list[str]] = {}
    current = None
    for raw in path.read_text().splitlines():
        line = raw.split(" #")[0].rstrip() if raw.lstrip().startswith("-") else raw.rstrip()
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if not line.startswith(" ") and line.endswith(":"):
            current = line[:-1]
            filters[current] = []
        elif line.lstrip().startswith("- ") and current:
            filters[current].append(line.lstrip()[2:].strip().strip("'\""))
        else:
            sys.exit(f"{path}: 読めない行です: {raw}")
    return filters


def glob_to_regex(pattern: str) -> re.Pattern[str]:
    """paths-filter（picomatch）の `**` `*` `?` を正規表現にする。"""
    out, i = "", 0
    while i < len(pattern):
        if pattern.startswith("**/", i):
            out += "(?:.*/)?"
            i += 3
        elif pattern.startswith("**", i):
            out += ".*"
            i += 2
        elif pattern[i] == "*":
            out += "[^/]*"
            i += 1
        elif pattern[i] == "?":
            out += "[^/]"
            i += 1
        else:
            out += re.escape(pattern[i])
            i += 1
    return re.compile(out + r"\Z")


def any_match(files: list[str], patterns: list[str]) -> bool:
    """some: いずれかのファイルがいずれかのパターンに一致する。"""
    regexes = [glob_to_regex(p) for p in patterns]
    return any(r.match(f) for f in files for r in regexes)


def any_code_change(files: list[str], patterns: list[str]) -> bool:
    """every: 全てのパターンを満たすファイルが 1 つある。`!` は除外。"""
    positive = [glob_to_regex(p) for p in patterns if not p.startswith("!")]
    negative = [glob_to_regex(p[1:]) for p in patterns if p.startswith("!")]
    return any(
        all(r.match(f) for r in positive) and not any(r.match(f) for r in negative) for f in files
    )


def resolve_gates(files: list[str]) -> tuple[bool, bool]:
    """ci.yml の `Resolve job gates` と同じ判定を返す（mobile, backend）。"""
    filters = load_filters(FILTER)
    code = any_code_change(files, load_filters(FILTER_CODE)["code"])
    mobile = any_match(files, filters["mobile"])
    backend = any_match(files, filters["backend"])
    if not code:
        return False, False
    if not mobile and not backend:
        return True, True
    return mobile, backend


def git(*args: str) -> str:
    # core.quotePath=false で、非 ASCII のパスが引用符付きのエスケープ表記にならないようにする。
    result = subprocess.run(["git", "-c", "core.quotePath=false", *args], cwd=ROOT, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    return result.stdout


def git_paths(*args: str) -> list[str]:
    """パスを返す git コマンドを `-z` 付きで実行し、NUL で分割する。日本語・空白・改行を含む名前も壊れない。"""
    return [p for p in git(args[0], "-z", *args[1:]).split("\0") if p]


def git_bytes(*args: str) -> bytes:
    result = subprocess.run(["git", *args], cwd=ROOT, capture_output=True)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.decode(errors="replace").strip())
    return result.stdout


def changed_files(base: str, head: str | None = None) -> list[str] | None:
    """base との merge-base からの変更。base が無ければ None。

    head が無ければ作業ツリー（未追跡を含む）まで、head があればその commit までを見る。
    名前変更は削除 + 追加として数え、変更前後のパスを両方含める。
    """
    try:
        merge_base = git("merge-base", base, head or "HEAD").strip()
    except RuntimeError:
        return None
    tracked = git_paths("diff", "--name-only", "--no-renames", merge_base, *([head] if head else []))
    untracked = [] if head else git_paths("ls-files", "--others", "--exclude-standard")
    return sorted(set(tracked + untracked))


# --- コマンド ---


def cmd_check(_: argparse.Namespace) -> int:
    return run_recipes([*DOCS_STEPS, *MOBILE_STEPS, *BACKEND_STEPS])


def run_for_files(files: list[str], base: str) -> int:
    mobile, backend = resolve_gates(files)
    print(f"変更 {len(files)} 件 → mobile={mobile} backend={backend}（基準: {base}）")
    steps = list(DOCS_STEPS)
    if mobile:
        steps += MOBILE_STEPS
    if backend:
        steps += BACKEND_STEPS
    return run_recipes(steps)


def cmd_check_changed(args: argparse.Namespace) -> int:
    files = changed_files(args.base)
    if files is None:
        print(f"{args.base} が無いため、全体を検証します。", file=sys.stderr)
        return cmd_check(args)
    return run_for_files(files, args.base)


def is_zero_sha(sha: str) -> bool:
    return set(sha) == {"0"}


def cmd_pre_push(args: argparse.Namespace) -> int:
    """pre-push の標準入力（`<local ref> <local sha> <remote ref> <remote sha>`）を読み、push 対象を検証する。

    検証は作業ツリーで走るため、検証できるのは HEAD を push するときだけ。変更範囲は作業ツリーではなく HEAD の commit から決める。
    HEAD と違う branch や tag の push は検証できないので、その旨を警告して飛ばす（CI が検証する）。
    """
    head = git("rev-parse", "HEAD").strip()
    verify = False
    for line in sys.stdin:
        parts = line.split()
        if len(parts) < 4:
            continue
        local_ref, local_sha = parts[0], parts[1]
        if is_zero_sha(local_sha):
            continue  # 削除の push
        if local_sha == head and local_ref.startswith("refs/heads/"):
            verify = True
        else:
            print(
                f"! {local_ref} は現在の HEAD ではないため、ローカルでは検証しません（CI が検証します）。"
                f"検証するには `git switch` してから push してください。",
                file=sys.stderr,
            )
    if not verify:
        print("- pre-push: 検証対象の ref がありません。")
        return 0
    dirty = [p for p in git_paths("status", "--porcelain=v1", "--untracked-files=no") if p]
    if dirty:
        print("! 未コミットの変更を含む作業ツリーで検証します。push されるのは commit 済みの内容だけです。", file=sys.stderr)
    files = changed_files(args.base, head)
    if files is None:
        print(f"{args.base} が無いため、全体を検証します。", file=sys.stderr)
        return cmd_check(args)
    return run_for_files(files, args.base)


def cmd_run(args: argparse.Namespace) -> int:
    return run_recipes(args.recipes)


def staged(*globs: str) -> list[str]:
    # R（名前変更）も含める。移動で壊れたリンクや、移動と同時の編集を検査から漏らさないため。
    return git_paths("diff", "--cached", "--name-only", "--diff-filter=ACMR", "--", *globs)


def unstaged_among(files: list[str]) -> set[str]:
    """index と作業ツリーの内容が違うファイル。部分ステージや、ステージ後の編集がある。"""
    return set(git_paths("diff", "--name-only", "--", *files)) if files else set()


def stdin_format_ok(label: str, make_cmd, files: list[str]) -> bool:
    """index の内容を整形器の標準入力に渡し、出力が入力と同じか確かめる。作業ツリーは読まない。"""
    ok = True
    for f in files:
        content = git_bytes("show", f":{f}")
        result = subprocess.run(make_cmd(f), input=content, capture_output=True, env=clean_env(), cwd=ROOT)
        if result.returncode != 0 or result.stdout != content:
            print(f"✗ {label}: ステージした内容が未整形です: {f}")
            ok = False
    return ok


def cmd_format_staged(_: argparse.Namespace) -> int:
    """ステージした Dart と backend の TypeScript が整形済みかを、index の内容で判定する（書き換えない）。

    作業ツリーと index が同じファイルはまとめて検査し、違うファイルは index の内容を標準入力で検査する。
    """
    dart = [f.removeprefix("mobile_app/") for f in staged("mobile_app/*.dart")]
    backend_roots = ("src/", "scripts/", "test/", "worker-test/")
    ts = [
        f.removeprefix("backend/")
        for f in staged("backend/*.ts", "backend/*.tsx")
        if f.removeprefix("backend/").startswith(backend_roots) or f == "backend/vitest.config.ts"
    ]
    if not dart and not ts:
        return 0
    diverged = unstaged_among([f"mobile_app/{f}" for f in dart] + [f"backend/{f}" for f in ts])
    dart_clean = [f for f in dart if f"mobile_app/{f}" not in diverged]
    dart_diverged = [f for f in dart if f"mobile_app/{f}" in diverged]
    ts_clean = [f for f in ts if f"backend/{f}" not in diverged]
    ts_diverged = [f for f in ts if f"backend/{f}" in diverged]
    logs = log_dir()
    prefix = tool_prefix()
    has_oxfmt = (ROOT / "backend" / "node_modules" / ".bin" / "oxfmt").exists()
    ok = True
    if dart_clean:
        ok &= run_step(
            "format-dart",
            in_dir(prefix, "mobile_app", ["dart", "format", "--set-exit-if-changed", "--output=none", *dart_clean]),
            logs,
        )
    if dart_diverged:
        # dart format は引数なしだと標準入力を整形して標準出力へ出す。
        ok &= stdin_format_ok(
            "format-dart",
            lambda f: in_dir(prefix, "mobile_app", ["dart", "format"]),
            [f"mobile_app/{f}" for f in dart_diverged],
        )
    if ts_clean or ts_diverged:
        if not has_oxfmt:
            print("- format-backend: backend の依存が未導入のため skip（just backend-setup）")
        else:
            if ts_clean:
                ok &= run_step("format-backend", in_dir(prefix, "backend", ["bunx", "oxfmt", "--check", *ts_clean]), logs)
            if ts_diverged:
                ok &= stdin_format_ok(
                    "format-backend",
                    lambda f: in_dir(prefix, "backend", ["bunx", "oxfmt", f"--stdin-filepath={f.removeprefix('backend/')}"]),
                    [f"backend/{f}" for f in ts_diverged],
                )
    if not ok:
        print("整形は `just format` で直せます。部分ステージしたファイルは、整形後に必要な部分を `git add` し直してください。")
    return 0 if ok else 1


def md_link_errors(rel: str, text: str, exists) -> list[str]:
    """text の相対リンクを検査する。リンク先の有無は exists(リポジトリ直下からの相対パス) で判定する。"""
    errors = []
    in_fence = False
    for no, line in enumerate(text.splitlines(), 1):
        if line.lstrip().startswith(("```", "~~~")):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        line = re.sub(r"`[^`]*`", "", line)
        for target in re.findall(r"\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)", line):
            if re.match(r"([a-zA-Z][a-zA-Z0-9+.-]*:|#|<)", target):
                continue
            path = unquote(target.split("#")[0].split("?")[0])
            if not path:
                continue
            resolved = posixpath.normpath(path.lstrip("/") if path.startswith("/") else posixpath.join(posixpath.dirname(rel), path))
            if resolved.startswith("..") or not exists(resolved):
                errors.append(f"{rel}:{no}: リンク先がありません: {target}")
    return errors


def index_exists():
    """index（ステージ内容）にファイルまたはディレクトリがあるかを返す関数。作業ツリーは見ない。"""
    entries = set()
    for p in git_paths("ls-files", "--cached"):
        entries.add(p)
        entries.update(str(parent) for parent in Path(p).parents if str(parent) != ".")
    entries.add(".")
    return entries.__contains__


def cmd_md_links(args: argparse.Namespace) -> int:
    """Markdown の相対リンクを検査する。既定はステージした内容（index）、--all は作業ツリー。"""
    if args.all:
        files = [f for f in git_paths("ls-files", "*.md") if (ROOT / f).exists()]
        exists = lambda p: (ROOT / p).exists()
        read = lambda f: (ROOT / f).read_text(errors="replace")
    else:
        files = staged("*.md")
        exists = index_exists()
        read = lambda f: git_bytes("show", f":{f}").decode(errors="replace")
    files = [f for f in files if not f.startswith(MD_LINK_EXCLUDES)]
    errors = [e for f in files for e in md_link_errors(f, read(f), exists)]
    for e in errors:
        print(e)
    print(f"{'✗' if errors else '✓'} md-links（{len(files)} ファイル、リンク切れ {len(errors)} 件）")
    return 1 if errors else 0


def cmd_debug_code(_: argparse.Namespace) -> int:
    """ステージした追加行のデバッグコードを報告する。commit は止めない。"""
    diff = git("diff", "--cached", "-U0", "--diff-filter=ACMR", "--", *DEBUG_CODE_GLOBS)
    found = [
        line for line in diff.splitlines() if line.startswith("+") and not line.startswith("+++") and DEBUG_CODE.search(line)
    ]
    if found:
        print("[デバッグコード検出] ステージした変更にデバッグコードが残っています:", file=sys.stderr)
        for line in found:
            print(line, file=sys.stderr)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("check", help="全体を検証する").set_defaults(func=cmd_check)
    changed = sub.add_parser("check-changed", help="変更範囲だけを検証する")
    changed.add_argument("--base", default=DEFAULT_BASE, help=f"比較元（既定: {DEFAULT_BASE}）")
    changed.set_defaults(func=cmd_check_changed)
    push = sub.add_parser("pre-push", help="pre-push の標準入力から push 対象を検証する")
    push.add_argument("--base", default=DEFAULT_BASE, help=f"比較元（既定: {DEFAULT_BASE}）")
    push.set_defaults(func=cmd_pre_push)
    run = sub.add_parser("run", help="just のレシピを要約付きで実行する")
    run.add_argument("recipes", nargs="+")
    run.set_defaults(func=cmd_run)
    sub.add_parser("format-staged", help="ステージしたファイルの整形を判定する").set_defaults(func=cmd_format_staged)
    md = sub.add_parser("md-links", help="Markdown の相対リンクを検査する")
    md.add_argument("--all", action="store_true", help="追跡中の全 Markdown を検査する")
    md.set_defaults(func=cmd_md_links)
    sub.add_parser("debug-code", help="ステージした変更のデバッグコードを報告する").set_defaults(func=cmd_debug_code)
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
