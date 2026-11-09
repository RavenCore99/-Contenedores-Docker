import subprocess
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class WrapperTests(unittest.TestCase):
    def test_linux_wrapper_exists_and_parses(self):
        script = ROOT / "iniciar.sh"
        self.assertTrue(script.exists())
        subprocess.run(["bash", "-n", str(script)], check=True)
        self.assertIn('exec "$VENV/bin/python" "$ROOT/launcher.py" "$@"', script.read_text())

    def test_windows_wrapper_uses_relative_location_and_parameters(self):
        script = ROOT / "iniciar.ps1"
        self.assertTrue(script.exists())
        text = script.read_text()
        self.assertIn("$PSScriptRoot", text)
        self.assertIn("servidores", text)
        self.assertIn("launcher.py", text)
        self.assertNotIn("C:\\home\\raven", text)


if __name__ == "__main__":
    unittest.main()
