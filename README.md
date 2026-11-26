# dotfiles

Personal configs for my machines, managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is a Stow "package" that mirrors the home directory, so Stow symlinks its contents into `~`.

## License notice

the only stuff that is under [this license](/LICENSE) are the [`deploy.sh`](/deploy.sh) script,
[`kitty` configurations](/kitty/.config/kitty/) and [`bash` configurations](/bash.config/bash).
Everything else has specific licenses, `gitui` has it's own License, all catppuccin themes too.
all 3 fonts are licensed under an OFL license, each has it's own in it's respective directory.

## Layout

```
dotfiles/
├── assets/ # wallpapers and a cat svg(it's from catppuccin's repos)
├── bat/.config/bat/
│   ├── themes/ #has just the catppuccin machiato theme
│   └── config.conf
├── bash/.config/bash/
│   ├── init.sh            # the one file ~/.bashrc sources
│   ├── aliases.sh         # aliases (eza, trash-cli, gh, ...)
│   └── integrations.sh    # starship, zoxide, fzf, ...
├── bat/.config/bat
│   ├── config.conf
│   └── themes
├── kitty/.config/kitty/
│   ├── kitty.conf
│   └── colors.conf        # muted synthwave palette
├── starship/.config/starship.toml
├── gitui/.config/gitui/theme.ron
├── bin/gitui              # prebuilt binary, copied to ~/.local/bin by deploy.sh
├── deploy.sh
└── .gitignore             # *.local, .env
```

`~/.bashrc` is **per-machine and not tracked**. It only gets one hook line appended by `deploy.sh`; everything shared lives in `~/.config/bash/`. Secrets and host-specific stuff go in `~/.bashrc.local` (git-ignored, sourced by `init.sh`).

## Usage

```bash
git clone https://github.com/Pixal-Byte/dotsillies.git ~/dotsillies
cd ~/dotsillies
./deploy.sh                      # default packages: bash starship
./deploy.sh bash starship kitty gitui   # desktop / laptop
./deploy.sh bash starship        # headless server
```

Requires `stow`. Stow refuses to overwrite real files, so move or delete conflicting ones first (e.g. an existing `~/.config/starship.toml`).

### What `deploy.sh` does

1. `set -euo pipefail`, then `cd` to the repo folder so relative paths always work.
2. Defaults to `bash starship` when no packages are given.
3. Ensures `~/.local/bin` exists.
4. If `gitui` was requested and isn't installed yet, copies `bin/gitui` to `~/.local/bin/` with `install -m 755`.
5. Filters the requested names down to real package folders and runs `stow -t "$HOME" --no-folding --restow` on them (`--no-folding` keeps real directories, so untracked files in `~/.config/kitty` etc. don't end up in the repo).
6. Appends the hook to `~/.bashrc` once (idempotent):
   ```bash
   [ -f ~/.config/bash/init.sh ] && . ~/.config/bash/init.sh  # dotfiles
   ```

## Bash config

`init.sh` loads `aliases.sh` and `integrations.sh`, then `~/.bashrc.local`. The files are **sourced**, not executed, so they don't need `+x`.

Everything is guarded so it silently does nothing on machines without the tool:

```bash
# integrations.sh
command -v starship >/dev/null && eval "$(starship init bash)"
command -v zoxide   >/dev/null && eval "$(zoxide init bash)"
command -v fzf      >/dev/null && eval "$(fzf --bash)"   # fzf 0.48+
```

```bash
# PATH, added once even if init.sh is sourced repeatedly
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
```

```bash
# aliases.sh: shared eza flags in one variable
if command -v eza >/dev/null; then
  _eza_base='--icons --group-directories-first --git'
  alias ls="eza $_eza_base"
  alias ll="eza $_eza_base -l --header"
  alias la="eza $_eza_base -la"
  alias lt="eza $_eza_base --tree --level=2"
  unset _eza_base
fi

# trash-cli (check the command names, not the package name)
if command -v trash-put >/dev/null; then
  alias tp='trash-put'
  alias tl='trash-list'
  alias te='trash-empty'
  alias trr='trash-restore'   # not "tr", which shadows the real tr
fi

# gh and its extensions
if command -v gh >/dev/null; then
  if [ -d "${XDG_DATA_HOME:-$HOME/.local/share}/gh/extensions/gh-dash" ]; then
    alias ghd='gh dash'
  fi
fi
```

## Kitty

- `ctrl+shift+t` opens a plain local tab (`new_tab`), so a new tab never inherits an ssh session and closing ssh doesn't close the tab.
- `ctrl+shift+enter` opens a window/split in the same cwd/host (`new_window_with_cwd`).
- `close_on_exit no` was removed, since it isn't a real kitty option.
- `colors.conf` is a muted synthwave palette: deep purple-black background (`#14101d`), a single saturated purple accent (`#b57bee`) for cursor, selection, active border and active tab, and pastel ANSI colors of similar lightness so nothing fights for attention.

Reload with `ctrl+shift+f5`.

## New information learned from errors ^-^

- **Nested paths:** the folder must mirror `~` exactly. `bash/.config/bash/init.sh` links to `~/.config/bash/init.sh`; missing the last `bash/` level means the hook finds nothing.
- **Stow target:** always pass `-t "$HOME"`, otherwise Stow links into the *parent* of wherever the repo is cloned.
- **`command -v tool`** checks that a tool exists without running it, unlike running the tool and reading its exit code.
- **Exit codes:** `0` means success and non-zero means failure, the opposite of boolean `true`/`false` in most languages.
- **Quoting:** backticks inside double quotes still run commands. Use single quotes for commit messages containing `` `code` ``.
- **`[ a && b ]` doesn't work.** Use `[ a ] && [ b ]` or `[[ a && b ]]`.
- **`set -e` and `&&` one-liners:** prefer `if` blocks in scripts that run under `set -e`.
- **Stale commit message** (not pushed yet): `git commit --amend --only -m '...'`.

## Todo / ideas

- Download the gitui release instead of committing the binary if a machine has a different CPU architecture.
- Warn on unknown package names in `deploy.sh` (skipping `bin`).
