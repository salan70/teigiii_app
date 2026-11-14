"""ui_review.py の単体テスト。実行: python3 -m unittest mobile_app/tool/ui_review/test_ui_review.py"""

import argparse
import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import ui_review as ur


def entry(target_id, state="default", variant="light", status="ok", warnings=None):
    return {
        "id": target_id,
        "state": state,
        "variant": variant,
        "file": f"{target_id}/{state}__{variant}.png",
        "status": status,
        **({"warnings": warnings} if warnings else {}),
    }


class MergeTest(unittest.TestCase):
    def test_replaces_selected_and_drops_removed(self):
        previous = [entry("a"), entry("b"), entry("gone")]
        fresh = [entry("a", status="failed")]
        merged = ur.merge_entries(previous, fresh, {"a"}, {"a", "b"})
        self.assertEqual([(e["id"], e["status"]) for e in merged], [("b", "ok"), ("a", "failed")])


class AccessTest(unittest.TestCase):
    def test_covers(self):
        self.assertTrue(ur.covers("teigiii-ui.oda79.me", "teigiii-ui.oda79.me"))
        self.assertTrue(ur.covers("https://teigiii-ui.oda79.me/*", "teigiii-ui.oda79.me"))
        self.assertFalse(ur.covers("other.oda79.me", "teigiii-ui.oda79.me"))

    def protects(self, app):
        with mock.patch.object(ur, "cf_get", return_value=[app]):
            return ur.access_protects("acc", "teigiii-ui.oda79.me", "t")

    def app(self, policies, **extra):
        return {"id": "x", "type": "self_hosted", "domain": "teigiii-ui.oda79.me", "policies": policies, **extra}

    def test_requires_allow_policy(self):
        email = [{"email": {"email": "a@example.com"}}]
        self.assertTrue(self.protects(self.app([{"decision": "allow", "include": email}])))
        self.assertFalse(self.protects(self.app([{"decision": "bypass", "include": email}])))

    def test_rejects_allow_for_everyone(self):
        everyone = [{"everyone": {}}]
        self.assertFalse(self.protects(self.app([{"decision": "allow", "include": everyone}])))
        mixed = [{"email": {"email": "a@example.com"}}, {"everyone": {}}]
        self.assertFalse(self.protects(self.app([{"decision": "allow", "include": mixed}])))

    def test_rejects_allow_without_include(self):
        self.assertFalse(self.protects(self.app([{"decision": "allow", "include": []}])))

    def test_ignores_non_self_hosted_apps(self):
        email = [{"email": {"email": "a@example.com"}}]
        app = self.app([{"decision": "allow", "include": email}], type="bookmark")
        self.assertFalse(self.protects(app))

    def test_fetches_policies_when_app_lists_only_references(self):
        email = [{"email": {"email": "a@example.com"}}]
        app = self.app([{"id": "p1"}])
        responses = {"/accounts/acc/access/apps": [app]}

        def fake_get(path, token):
            return responses.get(path, [{"decision": "allow", "include": email}])

        with mock.patch.object(ur, "cf_get", side_effect=fake_get):
            self.assertTrue(ur.access_protects("acc", "teigiii-ui.oda79.me", "t"))

    def test_hostname_comes_from_wrangler_config(self):
        self.assertEqual(ur.publish_hostname(), "teigiii-ui.oda79.me")


class PlaceholderEnvTest(unittest.TestCase):
    def test_swaps_env_and_restores_it(self):
        with tempfile.TemporaryDirectory() as tmp:
            mobile = Path(tmp)
            (mobile / ".env").write_text("SECRET=1\n", encoding="utf-8")
            with mock.patch.object(ur, "MOBILE_DIR", mobile):
                with ur.placeholder_env():
                    self.assertNotIn("SECRET", (mobile / ".env").read_text(encoding="utf-8"))
                self.assertEqual((mobile / ".env").read_text(encoding="utf-8"), "SECRET=1\n")
                with self.assertRaises(RuntimeError):
                    with ur.placeholder_env():
                        raise RuntimeError("build failed")
                self.assertEqual((mobile / ".env").read_text(encoding="utf-8"), "SECRET=1\n")
                self.assertFalse((mobile / ".env.ui-review-backup").exists())

    def test_removes_placeholder_when_no_env_existed(self):
        with tempfile.TemporaryDirectory() as tmp:
            mobile = Path(tmp)
            with mock.patch.object(ur, "MOBILE_DIR", mobile):
                with ur.placeholder_env():
                    self.assertTrue((mobile / ".env").exists())
                self.assertFalse((mobile / ".env").exists())


class GalleryTest(unittest.TestCase):
    def test_writes_index_and_target_pages(self):
        registry = ur.load_targets()
        target = registry["targets"][0]
        state = target["states"][0]
        entries = [entry(target["id"], state["id"], v["id"]) for v in registry["variants"]]
        manifest = {
            "generatedAt": "2026-01-01T00:00:00+09:00",
            "git": {"branch": "b", "head": "h", "dirty": False},
            "entries": entries,
        }
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp)
            ur.write_gallery(out, registry, manifest)
            index = (out / "index.html").read_text(encoding="utf-8")
            self.assertIn(target["id"], index)
            self.assertIn("撮っていない対象", index)
            self.assertTrue((out / target["id"] / "index.html").exists())


class CaptureTest(unittest.TestCase):
    """flutter test を差し替えて、cmd_capture の成否と既存成果物の扱いを確かめる。"""

    def setUp(self):
        self.registry = ur.load_targets()
        self.target = self.registry["targets"][0]

    def all_entries(self, target):
        return [
            entry(target["id"], s["id"], v)
            for s in target["states"]
            for v in ur.state_variants(self.registry, s)
        ]

    def run_capture(self, out, entries, code=0, only=None):
        def fake_run(command, **kwargs):
            if entries is None:
                raise FileNotFoundError("flutter")
            staging = Path(next(c for c in command if c.startswith("--dart-define=UI_REVIEW_OUT=")).split("=", 2)[2])
            for e in entries:
                png = staging / e["file"]
                png.parent.mkdir(parents=True, exist_ok=True)
                png.write_bytes(b"new")
            (staging / "results.json").write_text(json.dumps(entries), encoding="utf-8")
            return mock.Mock(returncode=code)

        args = argparse.Namespace(all=only is None, only=only, out=str(out))
        with mock.patch.object(ur.subprocess, "run", side_effect=fake_run), mock.patch.object(
            ur, "git_info", return_value={"branch": "b", "head": "h", "dirty": False}
        ):
            return ur.cmd_capture(args)

    def test_success_replaces_images(self):
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp)
            old = out / self.target["id"] / "old.png"
            old.parent.mkdir(parents=True)
            old.write_bytes(b"old")
            entries = [e for t in self.registry["targets"] for e in self.all_entries(t)]
            self.assertEqual(self.run_capture(out, entries, only=None), 0)
            self.assertFalse(old.exists())
            self.assertTrue((out / entries[0]["file"]).exists())
            self.assertFalse((out / ".staging").exists())

    def test_nonzero_exit_fails_even_if_all_entries_ok(self):
        with tempfile.TemporaryDirectory() as tmp:
            entries = self.all_entries(self.target)
            code = self.run_capture(Path(tmp), entries, code=1, only=self.target["id"])
            self.assertEqual(code, 1)

    def test_only_fails_when_requested_shots_are_missing(self):
        with tempfile.TemporaryDirectory() as tmp:
            entries = self.all_entries(self.target)[:-1]
            self.assertEqual(self.run_capture(Path(tmp), entries, only=self.target["id"]), 1)

    def test_only_passes_when_every_requested_shot_is_present(self):
        with tempfile.TemporaryDirectory() as tmp:
            entries = self.all_entries(self.target)
            self.assertEqual(self.run_capture(Path(tmp), entries, only=self.target["id"]), 0)

    def test_launch_failure_keeps_existing_artifacts(self):
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp)
            old = out / self.target["id"] / "default__light.png"
            old.parent.mkdir(parents=True)
            old.write_bytes(b"old")
            manifest = out / "manifest.json"
            manifest.write_text('{"entries": []}', encoding="utf-8")
            self.assertEqual(self.run_capture(out, None, only=self.target["id"]), 2)
            self.assertEqual(old.read_bytes(), b"old")
            self.assertEqual(manifest.read_text(encoding="utf-8"), '{"entries": []}')

    def test_missing_results_keeps_existing_artifacts(self):
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp)
            old = out / self.target["id"] / "default__light.png"
            old.parent.mkdir(parents=True)
            old.write_bytes(b"old")
            with mock.patch.object(ur.subprocess, "run", return_value=mock.Mock(returncode=1)):
                args = argparse.Namespace(all=False, only=self.target["id"], out=str(out))
                self.assertEqual(ur.cmd_capture(args), 1)
            self.assertEqual(old.read_bytes(), b"old")


class RegistryTest(unittest.TestCase):
    def test_ids_are_unique_and_states_present(self):
        registry = ur.load_targets()
        ids = [t["id"] for t in registry["targets"]]
        self.assertEqual(len(ids), len(set(ids)))
        for t in registry["targets"]:
            self.assertTrue(t["states"], t["id"])
            self.assertEqual(len({s["id"] for s in t["states"]}), len(t["states"]), t["id"])


if __name__ == "__main__":
    unittest.main()
