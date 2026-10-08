# dotfiles

Personal dotfiles, managed with [chezmoi](https://chezmoi.io/). One repo serves
both personal and work Macs; a per-machine flag decides what each one gets.

## New machine

```sh
chezmoi init plttn/dotfiles   # prompts below
chezmoi diff                  # review before writing anything
chezmoi apply
fisher update                 # fish plugins from fish_plugins
mise install                  # tools from mise/config.toml
```

`chezmoi init` asks for:

- **Name** and **Email**: the personal identity, used everywhere by default.
- **Is this a work machine**: sets `is_work`.
- **Work email**: only asked on work machines.

The first `chezmoi apply` fetches the age key from 1Password (one approval), so
the 1Password CLI needs access to the personal account. After that the key
lives at `~/.config/chezmoi/key.txt` and decryption needs no prompts.

Re-run `chezmoi init` whenever `.chezmoi.toml.tmpl` changes; chezmoi warns when
it does. `chezmoi init --data=false` asks every question again.

## Personal and work machines

Templates branch on `is_work`:

- **Shared files** go everywhere. Lines that differ use `{{ if .is_work }}`.
- **Work-only files** are age-encrypted (`encrypted_*.age`) and listed in the
  `else` branch of `.chezmoiignore`, so personal machines never get them.
- **Personal-only files** go in the `if .is_work` branch of `.chezmoiignore`.

Tools that read a whole directory make this easy: fish loads
`~/.config/fish/conf.d/*`, jj loads `~/.config/jj/conf.d/*.toml`, and the SSH
config includes `~/.ssh/config.d/*`. Work settings go in an encrypted file in
those directories, so the public config stays generic. Git does the same with
an `[include]` of an encrypted `work.conf`.

### Identities

Public keys live in `.chezmoidata.toml`. Git and jj use the personal identity
by default on personal machines and the work identity by default on work
machines, with per-org overrides in the encrypted work files.

## Encryption

This repo is public. Anything that names internal hosts, orgs, vaults, people
or tools goes in an encrypted file:

```sh
chezmoi add --encrypt ~/path/to/file
chezmoi edit ~/path/to/file        # decrypts, opens the editor, re-encrypts
```

Encrypted files can also be templates (`encrypted_name.tmpl.age`).

## Homebrew

Three files in the repo root track packages. chezmoi doesn't deploy them.

| File | Installed on |
|---|---|
| `Brewfile` | every machine |
| `Brewfile.work` | work machines |
| `Brewfile.ignore` | nowhere: installed on purpose, not tracked |

- **Sorting drift:** run `brew-drift` now and then. It lists what's installed
  but untracked (track as shared or work, ignore, uninstall, skip) and what's
  tracked but missing (install, remove, skip). Packages from third-party taps
  bring their tap along.
- **Installing:** `chezmoi apply` runs `brew bundle install --no-upgrade`
  whenever a Brewfile changes. It installs what's missing and never upgrades.
- **Committing:** `brew-drift` prints the commit command when it finishes.

## Notes

- `git.autoCommit` is on, so `chezmoi add` and `chezmoi forget` commit
  everything pending in the source directory. Commit other edits first.
- chezmoi doesn't delete files that leave the repo. Remove them by hand, or
  list them in `.chezmoiremove`.
- `~/.claude/CLAUDE.md` holds the shared Claude Code instructions. On work
  machines it imports an encrypted `~/.claude/work.md`.

## License

MIT
