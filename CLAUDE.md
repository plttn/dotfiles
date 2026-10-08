# Working in this repo

This is a chezmoi source directory for public dotfiles. Read README.md for the
layout. These rules cover what isn't obvious from the files.

## The repo is public

- Internal names (work hosts, org names, vault and item names, work emails,
  internal tool names) only go in encrypted files. That includes comments and
  commit messages.
- Before any push, search unencrypted tracked files and the unpushed history:

  ```sh
  git ls-files | grep -v '\.age$' | xargs grep -niE '<internal terms>'
  git --no-pager log -p --no-ext-diff origin/main..HEAD -- . ':(exclude)*.age'
  ```

- Public keys are fine to commit. Private keys never are.

## SSH and GitHub

- Never add a global `Host github.com` rule, and never change which key the
  agent offers by default. The work identity must stay the default: private Go
  modules clone from Go's module cache, outside any folder rule, and a
  different default breaks them.
- Per-identity behavior lives in folder-based `Match exec` rules in the
  encrypted `~/.ssh/config.d/work`. Extend those instead.
- The dotfiles remote uses SSH. Don't switch it to HTTPS: `gh` supplies the
  token there, and its active account is the work one.
- Check an identity with `ssh -T git@github.com` from the folder in question.

## chezmoi gotchas

- `git.autoCommit = true`: `chezmoi add`, `forget` and similar commands commit
  everything pending in the source directory. Commit or ask about pending work
  first.
- chezmoi prompts before overwriting a file that changed since its last write.
  The prompt needs a TTY and fails here. Diff the file, keep anything the user
  added (copy it into the source first), and only then use `--force`.
- Files in the repo root (README.md, CLAUDE.md, the Brewfiles) must stay in
  `.chezmoiignore`, or chezmoi deploys them to `~`.
- Work-only targets belong in the `else` branch of `.chezmoiignore`.
- `chezmoi edit` opens an interactive editor and won't work here. For
  encrypted files: `chezmoi decrypt < file.age > tmp`, edit, then
  `chezmoi encrypt < tmp > file.age`. Keep the `.tmpl.age` suffix for
  encrypted templates.
- Templates use `missingkey=error`; a new data key needs a value on every
  machine (`""` or `false` when it doesn't apply).

## Testing changes

- Render templates for both machine types with scratch configs instead of the
  real one: write a config with `is_work = true` and one with `false`, then
  `chezmoi --config <scratch> execute-template < file.tmpl` or
  `chezmoi --config <scratch> cat ~/target`.
- `chezmoi --config <scratch> managed` shows which targets a machine type gets.
- `brew-drift` needs fzf and a TTY. Test it with `fish --no-config` (so the
  user's fish config doesn't reorder `PATH`) and a stand-in `fzf` script that
  prints scripted selections.

## 1Password

- Each `op` call costs the user a biometric approval. Never run `op` to
  explore. Templates that call `onepasswordRead` cost one approval per
  `chezmoi diff`/`status`/`apply` on machines that render them.
- The age key fetch script runs `op read` only when the key file is missing.

## Homebrew

- `brew bundle dump` prints the installed set in Brewfile form, with options
  such as `trusted: true` and custom tap URLs. Copy entries from it rather
  than writing them by hand or with `brew bundle add`, which drops options.
- `brew bundle remove --formula` fails for formulae that no longer exist, and
  without `--formula` it leaves the description comment behind.
  `brew-drift` edits the text directly for that reason.
