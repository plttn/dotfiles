"""Check chezmoi setup without using the real home, network, or 1Password."""

import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parent.parent
TOOLS = {name: shutil.which(name) for name in ("chezmoi", "fish", "shellcheck")}
COMPLETION = ROOT / "private_dot_config/private_fish/completions/mise.fish"


class SetupChecks(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory(prefix="dotfiles-check-")
        self.addCleanup(self.scratch.cleanup)
        self.base = Path(self.scratch.name)
        self.home = self.base / "home"
        self.bin = self.base / "bin"
        self.tmp = self.base / "tmp"
        for directory in (self.home, self.bin, self.tmp):
            directory.mkdir()
        self.env = {
            **os.environ,
            "HOME": str(self.home),
            "XDG_CONFIG_HOME": str(self.home / ".config"),
            "XDG_CACHE_HOME": str(self.home / ".cache"),
            "XDG_DATA_HOME": str(self.home / ".local/share"),
            "TMPDIR": str(self.tmp),
            "PATH": f"{self.bin}:/usr/bin:/bin:/usr/sbin:/sbin",
            "CALL_LOG": str(self.base / "calls"),
        }
        for name in ("op", "curl"):
            self.stub(name, 'echo "Unexpected external call" >&2\nexit 99\n')

    def run_command(self, *args, input=None, succeeds=True):
        result = subprocess.run(
            [str(arg) for arg in args], input=input, text=True,
            capture_output=True, env=self.env, cwd=ROOT,
        )
        if succeeds:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def executable(self, path, body):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text("#!/bin/sh\nset -eu\n" + body)
        path.chmod(0o755)

    def stub(self, name, body):
        self.executable(self.bin / name, body)

    def script(self, name, **kwargs):
        return self.run_command("/bin/sh", ROOT / name, **kwargs)

    def chezmoi(self, work, *args, input=None):
        config = self.base / "chezmoi.toml"
        config.write_text(
            'encryption = "age"\n'
            '[data]\nname = "Test"\nemail = "test@example.invalid"\n'
            f'is_work = {str(work).lower()}\n'
            'work_email = "work@example.invalid"\n'
        )
        return self.run_command(
            TOOLS["chezmoi"], "--config", config, "--source", ROOT,
            "--destination", self.home, "--cache", self.base / "cache",
            "--persistent-state", self.base / "state.boltdb", "--no-tty",
            *args, input=input,
        ).stdout

    def test_machine_templates_and_targets(self):
        for work in (False, True):
            with self.subTest(work=work):
                rendered = self.chezmoi(
                    work, "execute-template", "--init", "--stdinisatty=false",
                    input=(ROOT / ".chezmoi.toml.tmpl").read_text(),
                )
                # Ask chezmoi's TOML parser to check the generated config too.
                generated = self.base / "generated.toml"
                generated.write_text(rendered)
                auto_commit = self.run_command(
                    TOOLS["chezmoi"], "--config", generated, "--no-tty",
                    "dump-config", "--format", "json",
                )
                self.assertIn("autoCommit = false", rendered)
                self.assertFalse(json.loads(auto_commit.stdout)["git"].get("autoCommit", False))
                targets = set(self.chezmoi(work, "managed").splitlines())
                for excluded in ("bootstrap-age-key.sh", "tests", "README.md", "AGENTS.md"):
                    self.assertFalse(any(t == excluded or t.startswith(excluded + "/") for t in targets))
                self.assertIn(".config/fish/completions/mise.fish", targets)
                self.assertEqual(".config/git/work.conf" in targets, work)
                self.assertEqual(".config/halloy/config.toml" in targets, not work)
                for template in ROOT.glob("run_*.tmpl"):
                    script = self.base / (template.stem + ".rendered.sh")
                    script.write_text(self.chezmoi(work, "execute-template", input=template.read_text()))
                    self.run_command(TOOLS["shellcheck"], "--shell=sh", script)

    def test_age_key_success_and_existing_key(self):
        self.stub("op", 'echo op >> "$CALL_LOG"\nprintf "AGE-SECRET-KEY-TEST\\n"\n')
        self.script("bootstrap-age-key.sh")
        key = self.home / ".config/chezmoi/key.txt"
        self.assertEqual(key.read_text(), "AGE-SECRET-KEY-TEST\n")
        self.assertEqual(stat.S_IMODE(key.stat().st_mode), 0o600)
        self.script("bootstrap-age-key.sh")
        self.assertEqual((self.base / "calls").read_text(), "op\n")
        self.assertEqual(list(key.parent.glob("key.txt.tmp.*")), [])

    def test_age_key_failed_and_malformed_fetch(self):
        key = self.home / ".config/chezmoi/key.txt"
        key.parent.mkdir(parents=True)
        for output, exit_code in (("AGE-SECRET-KEY-PARTIAL", 1), ("not a key", 0)):
            with self.subTest(exit_code=exit_code):
                self.stub("op", f"echo {output!r}\nexit {exit_code}\n")
                self.script("bootstrap-age-key.sh", succeeds=False)
                self.assertFalse(key.exists())
                self.assertEqual(list(key.parent.glob("key.txt.tmp.*")), [])
                key.write_text("")
                self.script("bootstrap-age-key.sh", succeeds=False)
                self.assertEqual(key.read_text(), "")
                key.unlink()
                self.assertEqual(list(key.parent.glob("key.txt.tmp.*")), [])

    def installer(self, body):
        payload = self.base / "installer.sh"
        payload.write_text("#!/bin/sh\nset -eu\n" + body)
        self.env["INSTALLER_PAYLOAD"] = str(payload)
        self.stub("curl", '''
echo curl >> "$CALL_LOG"
[ "$1" = -fsSL ]
[ "$2" = https://mise.run ]
[ "$3" = -o ]
cp "$INSTALLER_PAYLOAD" "$4"
''')

    def test_mise_install_and_existing_binary(self):
        self.installer('mkdir -p "$HOME/.local/bin"\nprintf "#!/bin/sh\\n" > "$HOME/.local/bin/mise"\nchmod 755 "$HOME/.local/bin/mise"\n')
        self.script("run_before_install-mise.sh")
        self.assertTrue(os.access(self.home / ".local/bin/mise", os.X_OK))
        self.script("run_before_install-mise.sh")
        self.assertEqual((self.base / "calls").read_text(), "curl\n")
        self.assertEqual(list(self.tmp.iterdir()), [])

    def test_mise_failures(self):
        self.stub("curl", 'echo partial > "$4"\nexit 1\n')
        self.script("run_before_install-mise.sh", succeeds=False)
        self.assertEqual(list(self.tmp.iterdir()), [])
        for body in ("exit 1\n", "exit 0\n"):
            with self.subTest(installer=body):
                self.installer(body)
                self.script("run_before_install-mise.sh", succeeds=False)
                self.assertFalse((self.home / ".local/bin/mise").exists())
                self.assertEqual(list(self.tmp.iterdir()), [])

    def test_fish_completion(self):
        # Fish has its own idea of HOME: start it with the scratch environment.
        self.run_command(TOOLS["fish"], "--no-config", "--command", f"source {COMPLETION}; complete -C 'mise '")
        mise = self.home / ".local/bin/mise"
        self.executable(mise, '''
echo "$*" >> "$CALL_LOG"
[ "$1" = completion ] && [ "$2" = fish ]
echo 'complete -c mise -f -a dotfiles_test_completion'
''')
        completion_dir = self.home / ".config/fish/completions"
        completion_dir.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(COMPLETION, completion_dir / "mise.fish")
        result = self.run_command(
            TOOLS["fish"], "--no-config", "--command",
            "set -gx PATH $HOME/.local/bin $PATH; "
            "set -g fish_complete_path $HOME/.config/fish/completions; complete -C 'mise '",
        )
        self.assertIn("dotfiles_test_completion", result.stdout)
        self.assertEqual((self.base / "calls").read_text(), "completion fish\n")

    def test_syntax(self):
        shell_files = [ROOT / "bootstrap-age-key.sh", ROOT / "run_before_install-mise.sh", ROOT / "tests/check.sh"]
        self.run_command(TOOLS["shellcheck"], *shell_files)
        for script in shell_files:
            self.run_command("/bin/sh", "-n", script)
        for script in (ROOT / "private_dot_config/private_fish/config.fish", COMPLETION):
            self.run_command(TOOLS["fish"], "--no-config", "--no-execute", script)


if __name__ == "__main__":
    unittest.main(verbosity=2)
