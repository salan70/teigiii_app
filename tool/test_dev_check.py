"""dev_check.py の単体テスト。一時 Git リポジトリで index と作業ツリーの扱いを確かめる。

実行: python3 -m unittest discover -s tool -p 'test_*.py'
"""
import contextlib
import io
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))
import dev_check  # noqa: E402

ZERO = "0" * 40


def sh(root: Path, *args: str) -> str:
    return subprocess.run(["git", "-C", str(root), *args], check=True, capture_output=True, text=True).stdout.strip()


class GitRepoCase(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.root = Path(self._tmp.name).resolve()
        sh(self.root, "init", "-q", "-b", "develop")
        sh(self.root, "config", "user.email", "t@example.com")
        sh(self.root, "config", "user.name", "t")
        self._root = dev_check.ROOT
        dev_check.ROOT = self.root
        # hook 経由の環境変数が混ざらないようにする
        for key in ("GIT_DIR", "GIT_INDEX_FILE", "GIT_WORK_TREE"):
            os.environ.pop(key, None)

    def tearDown(self) -> None:
        dev_check.ROOT = self._root
        self._tmp.cleanup()

    def write(self, rel: str, text: str) -> None:
        path = self.root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)

    def commit(self) -> None:
        sh(self.root, "add", "-A")
        sh(self.root, "commit", "-q", "-m", "c")


class StagedTest(GitRepoCase):
    def test_japanese_file_name_is_not_quoted(self) -> None:
        self.write("doc/設計.md", "[x](missing.md)\n")
        sh(self.root, "add", "doc/設計.md")
        self.assertEqual(dev_check.staged("*.md"), ["doc/設計.md"])

    def test_renamed_file_is_included(self) -> None:
        self.write("a/old.md", "# t\n" * 10)
        self.commit()
        sh(self.root, "mv", "a/old.md", "a/new.md")
        self.assertEqual(dev_check.staged("*.md"), ["a/new.md"])

    def test_changed_files_use_both_sides_of_rename(self) -> None:
        self.write("a/old.md", "# t\n" * 10)
        self.commit()
        sh(self.root, "branch", "base")
        sh(self.root, "mv", "a/old.md", "a/新しい.md")
        self.commit()
        self.assertEqual(dev_check.changed_files("base", "HEAD"), ["a/old.md", "a/新しい.md"])

    def test_changed_files_with_head_ignores_worktree(self) -> None:
        self.write("a.md", "a\n")
        self.commit()
        sh(self.root, "branch", "base")
        self.write("b.md", "uncommitted\n")
        self.assertEqual(dev_check.changed_files("base", "HEAD"), [])
        self.assertEqual(dev_check.changed_files("base"), ["b.md"])

    def test_unstaged_among_detects_partial_stage(self) -> None:
        self.write("a.dart", "void main() {}\n")
        self.write("b.dart", "void main() {}\n")
        self.commit()
        self.write("a.dart", "void main() { }\n")
        sh(self.root, "add", "a.dart")
        self.write("a.dart", "void main(){}\n")
        self.write("b.dart", "void main(){}\n")
        sh(self.root, "add", "b.dart")
        self.assertEqual(dev_check.unstaged_among(["a.dart", "b.dart"]), {"a.dart"})


class MdLinksTest(GitRepoCase):
    def run_md_links(self, all_: bool = False) -> tuple[int, str]:
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = dev_check.cmd_md_links(type("A", (), {"all": all_})())
        return code, out.getvalue()

    def test_checks_staged_content_not_worktree(self) -> None:
        self.write("doc/a.md", "[x](b.md)\n")
        self.write("doc/b.md", "b\n")
        self.commit()
        # ステージした内容はリンク切れ、作業ツリーでは直っている
        self.write("doc/a.md", "[x](gone.md)\n")
        sh(self.root, "add", "doc/a.md")
        self.write("doc/a.md", "[x](b.md)\n")
        code, out = self.run_md_links()
        self.assertEqual(code, 1, out)
        self.assertIn("gone.md", out)

    def test_staged_ok_even_if_worktree_is_broken(self) -> None:
        self.write("doc/a.md", "[x](b.md)\n")
        self.write("doc/b.md", "b\n")
        self.commit()
        self.write("doc/a.md", "[x](b.md) \n")
        sh(self.root, "add", "doc/a.md")
        self.write("doc/a.md", "[x](gone.md)\n")
        self.assertEqual(self.run_md_links()[0], 0)

    def test_link_to_untracked_file_is_broken(self) -> None:
        self.write("doc/a.md", "# a\n")
        self.commit()
        self.write("doc/a.md", "[x](untracked.md)\n")
        self.write("doc/untracked.md", "u\n")
        sh(self.root, "add", "doc/a.md")
        self.assertEqual(self.run_md_links()[0], 1)

    def test_renamed_markdown_with_broken_relative_link(self) -> None:
        self.write("doc/a.md", "[x](b.md)\n")
        self.write("doc/b.md", "b\n")
        self.commit()
        (self.root / "doc/sub").mkdir()
        sh(self.root, "mv", "doc/a.md", "doc/sub/設計.md")
        code, out = self.run_md_links()
        self.assertEqual(code, 1, out)
        self.assertIn("doc/sub/設計.md:1", out)

    def test_directory_and_root_links(self) -> None:
        self.write("doc/a.md", "[d](../src) [r](/doc/b.md#h) [u](https://e.com)\n")
        self.write("src/x.txt", "x\n")
        self.write("doc/b.md", "b\n")
        self.commit()
        self.write("doc/a.md", "[d](../src) [r](/doc/b.md#h) [u](https://e.com) \n")
        sh(self.root, "add", "doc/a.md")
        self.assertEqual(self.run_md_links()[0], 0)

    def test_all_reads_japanese_names(self) -> None:
        self.write("doc/設計.md", "[x](missing.md)\n")
        self.commit()
        code, out = self.run_md_links(all_=True)
        self.assertEqual(code, 1, out)


class PrePushTest(GitRepoCase):
    def run_pre_push(self, stdin_text: str) -> tuple[int, str]:
        err = io.StringIO()
        self.calls: list[list[str]] = []
        orig_run, orig_stdin = dev_check.run_for_files, sys.stdin
        dev_check.run_for_files = lambda files, base: self.calls.append(files) or 0
        sys.stdin = io.StringIO(stdin_text)
        try:
            with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(err):
                code = dev_check.cmd_pre_push(type("A", (), {"base": "base"})())
        finally:
            dev_check.run_for_files, sys.stdin = orig_run, orig_stdin
        return code, err.getvalue()

    def setup_branches(self) -> str:
        """develop は変更なし、feature は f.txt を足した状態にして develop へ戻る。feature の sha を返す。"""
        self.write("a.md", "a\n")
        self.commit()
        sh(self.root, "branch", "base")
        sh(self.root, "switch", "-q", "-c", "feature")
        self.write("f.txt", "f\n")
        self.commit()
        feature = sh(self.root, "rev-parse", "HEAD")
        sh(self.root, "switch", "-q", "develop")
        return feature

    def test_other_ref_is_warned_and_not_verified(self) -> None:
        feature = self.setup_branches()
        code, err = self.run_pre_push(f"refs/heads/feature {feature} refs/heads/feature {ZERO}\n")
        self.assertEqual(code, 0)
        self.assertEqual(self.calls, [])
        self.assertIn("refs/heads/feature は現在の HEAD ではない", err)

    def test_head_ref_is_verified_from_commits(self) -> None:
        feature = self.setup_branches()
        sh(self.root, "switch", "-q", "feature")
        self.write("untracked.txt", "dirty\n")
        code, _ = self.run_pre_push(f"refs/heads/feature {feature} refs/heads/feature {ZERO}\n")
        self.assertEqual(code, 0)
        self.assertEqual(self.calls, [["f.txt"]])

    def test_delete_push_is_ignored(self) -> None:
        self.setup_branches()
        code, err = self.run_pre_push(f"(delete) {ZERO} refs/heads/x {'1' * 40}\n")
        self.assertEqual((code, self.calls, err), (0, [], ""))


if __name__ == "__main__":
    unittest.main()
