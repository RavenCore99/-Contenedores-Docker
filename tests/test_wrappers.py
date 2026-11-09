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

    def test_windows_cmd_entry_is_location_independent(self):
        script = ROOT / "activar.cmd"
        self.assertTrue(script.exists())
        text = script.read_text(encoding="utf-8")
        self.assertIn('cd /d "%~dp0"', text)
        self.assertIn("requirements-cli.txt", text)
        self.assertIn("launcher.py", text)
        self.assertIn("docker compose", text)
        self.assertIn("winget", text)
        self.assertIn("--servidores", text)
        self.assertNotIn("H:\\tensors", text)
        self.assertNotIn("C:\\home\\raven", text)

    def test_windows_ps1_delegates_to_activar_cmd(self):
        script = ROOT / "iniciar.ps1"
        self.assertTrue(script.exists())
        text = script.read_text(encoding="utf-8")
        self.assertIn("$PSScriptRoot", text)
        self.assertIn("activar.cmd", text)
        self.assertIn("servidores", text)
        self.assertNotIn("C:\\home\\raven", text)


if __name__ == "__main__":
    unittest.main()
