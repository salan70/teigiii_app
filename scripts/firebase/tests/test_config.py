import importlib.util
import io
from pathlib import Path
import plistlib
import tempfile
import unittest
from contextlib import redirect_stdout
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('config', Path(__file__).parents[1] / 'config.py')
config = importlib.util.module_from_spec(spec)
spec.loader.exec_module(config)


class ConfigurationTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.ios = dict(PROJECT_ID='everyone-teigi-dev', BUNDLE_ID='com.toda.teigiii.dev', GOOGLE_APP_ID='ios-app',
                        API_KEY='fixture', GCM_SENDER_ID='123', CLIENT_ID='123.apps.googleusercontent.com',
                        REVERSED_CLIENT_ID='com.googleusercontent.apps.123')
        self.apps = [dict(platform='IOS', bundleId=self.ios['BUNDLE_ID'], appId='ios-app', projectId=self.ios['PROJECT_ID'])]
        self.dart = self.root / 'mobile_app/lib/util/firebase_options/firebase_options_dev.dart'
        self.dart.parent.mkdir(parents=True)
        self.dart.write_text("static const FirebaseOptions ios = FirebaseOptions(\n"
                             "    appId: 'ios-app',\n    projectId: 'everyone-teigi-dev',\n"
                             "    iosBundleId: 'com.toda.teigiii.dev',\n  );\n")

    def cli(self, *args):
        self.assertEqual(args[1], 'IOS')
        return self.apps if args[0] == 'apps:list' else dict(fileContents=plistlib.dumps(self.ios).decode())

    def configure(self):
        with patch.object(config, 'firebase', self.cli):
            config.configure(self.root, 'dev')

    def snapshot(self):
        return {p: p.read_bytes() for p in self.root.rglob('*') if p.is_file()}

    def test_bootstrap_and_idempotence(self):
        self.configure()
        before = [(p.read_bytes(), p.stat().st_mtime_ns) for p in config.paths(self.root, 'dev')]
        self.configure()
        self.assertEqual(before, [(p.read_bytes(), p.stat().st_mtime_ns) for p in config.paths(self.root, 'dev')])
        config.check(self.root, 'dev')
        self.assertFalse((self.root / 'mobile_app/android').exists())

    def test_android_untouched(self):
        android = self.root / 'mobile_app/android/google-services.json'
        android.parent.mkdir(parents=True)
        android.write_bytes(b'unrelated invalid json')
        self.configure()
        config.check(self.root, 'dev')
        self.assertEqual(android.read_bytes(), b'unrelated invalid json')

    def test_fixed_prod_identity(self):
        self.assertEqual(config.identity(self.root, 'prod'), ('everyone-teigi-prod', 'com.toda.teigiii'))
        self.ios.update(PROJECT_ID='everyone-teigi-prod', BUNDLE_ID='com.toda.teigiii')
        config.validate(plistlib.dumps(self.ios), *config.identity(self.root, 'prod'))

    def test_mismatches_preserve_files(self):
        self.configure()
        for key in ['PROJECT_ID', 'BUNDLE_ID', 'GOOGLE_APP_ID', 'CLIENT_ID', 'REVERSED_CLIENT_ID']:
            original = self.ios[key]
            self.ios[key] = 'wrong'
            before = self.snapshot()
            with self.assertRaises(config.ConfigError):
                self.configure()
            self.assertEqual(before, self.snapshot())
            self.ios[key] = original

    def test_exact_bundle_and_duplicate(self):
        old = dict(self.apps[0], bundleId='com.toda.teigiApp.dev')
        args = ('com.toda.teigiii.dev', 'everyone-teigi-dev')
        self.assertEqual(config.select_app([old, *self.apps], *args), 'ios-app')
        for apps in [[old], self.apps * 2]:
            with self.assertRaises(config.ConfigError):
                config.select_app(apps, *args)

    def test_corrupt_fetch_preserves_files(self):
        self.configure()
        before = self.snapshot()
        def cli(*args):
            return self.apps if args[0] == 'apps:list' else dict(fileContents='broken')
        with patch.object(config, 'firebase', cli), self.assertRaises(Exception):
            config.configure(self.root, 'dev')
        self.assertEqual(before, self.snapshot())

    def test_missing_generated_config(self):
        self.configure()
        config.paths(self.root, 'dev')[1].unlink()
        with self.assertRaisesRegex(config.ConfigError, 'xcconfig missing'):
            config.check(self.root, 'dev')

    def test_dart_identity_mismatch_preserves_configuration(self):
        self.configure()
        original = self.dart.read_text()
        for value in ['ios-app', 'everyone-teigi-dev', 'com.toda.teigiii.dev']:
            self.dart.write_text(original.replace(value, 'wrong'))
            before = self.snapshot()
            with self.assertRaisesRegex(config.ConfigError, 'FirebaseOptions .* mismatch'):
                self.configure()
            with self.assertRaisesRegex(config.ConfigError, 'FirebaseOptions .* mismatch'):
                config.check(self.root, 'dev')
            self.assertEqual(before, self.snapshot())
        self.dart.write_text(original)

    def test_missing_dart_ios_section_preserves_configuration(self):
        self.dart.write_text('no iOS options')
        before = self.snapshot()
        with self.assertRaisesRegex(config.ConfigError, 'Cannot identify iOS FirebaseOptions'):
            self.configure()
        self.assertEqual(before, self.snapshot())

    def test_replace_failure_rollback_cleanup(self):
        self.configure()
        before = self.snapshot()
        self.ios.update(CLIENT_ID='456.apps.googleusercontent.com', REVERSED_CLIENT_ID='com.googleusercontent.apps.456')
        original = config.os.replace
        calls = 0
        def replace(source, destination):
            nonlocal calls
            calls += 1
            if calls == 2:
                raise OSError('mock failure')
            return original(source, destination)
        with patch.object(config.os, 'replace', replace), self.assertRaises(OSError):
            self.configure()
        self.assertEqual(before, self.snapshot())

    def test_write_failure_cleanup(self):
        self.configure()
        before = self.snapshot()
        original = config.tempfile.NamedTemporaryFile
        def temporary(*args, **kwargs):
            out = original(*args, **kwargs)
            out.write = lambda data: (_ for _ in ()).throw(OSError('mock write failure'))
            return out
        self.ios['API_KEY'] = 'changed'
        with patch.object(config.tempfile, 'NamedTemporaryFile', temporary), self.assertRaises(OSError):
            self.configure()
        self.assertEqual(before, self.snapshot())

    def test_audit_complete_not_ok(self):
        output = io.StringIO()
        with patch.object(config.sys, 'argv', ['config.py', 'audit', 'dev']), patch.object(config, 'audit'), redirect_stdout(output):
            self.assertEqual(config.main(), 0)
        self.assertIn('complete', output.getvalue())
        self.assertNotIn('OK', output.getvalue())


if __name__ == '__main__':
    unittest.main()
