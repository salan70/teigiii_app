"""ui_review.py の単体テスト。実行: python3 -m unittest mobile_app/tool/ui_review/test_ui_review.py"""

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

    def test_requires_allow_policy(self):
        app = {"id": "x", "domain": "teigiii-ui.oda79.me", "policies": [{"decision": "allow"}]}
        with mock.patch.object(ur, "cf_get", return_value=[app]):
            self.assertTrue(ur.access_protects("acc", "teigiii-ui.oda79.me", "t"))
        app["policies"] = [{"decision": "bypass"}]
        with mock.patch.object(ur, "cf_get", return_value=[app]):
            self.assertFalse(ur.access_protects("acc", "teigiii-ui.oda79.me", "t"))

    def test_hostname_comes_from_wrangler_config(self):
        self.assertEqual(ur.publish_hostname(), "teigiii-ui.oda79.me")


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
