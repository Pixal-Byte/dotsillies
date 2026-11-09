#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

# usage: ./deploy.sh [package...]   (default: bash starship)
requested=("$@")
[ ${#requested[@]} -eq 0 ] && requested=(bash starship)

command -v stow >/dev/null || { echo "install stow first"; exit 1; }

#persisting required directories
mkdir -p "$HOME/.local/bin"

#verifing if gitui is already installed or not.
if [[ " ${requested[*]} " == *" gitui "*  ]] && [ ! -e "$HOME/.local/bin/gitui" ]; then
	[ -f bin/gitui ] || { echo "bin/gitui missing from repo" >&2; exit 1; }
	echo "=== No gitui binary found already installed. copying from ./bin==="
	install -m 755 bin/gitui "$HOME/.local/bin/gitui"
fi

# --no-folding keeps real directories, so untracked files in ~/.config/kitty
# etc. don't end up inside the repo
stow --no-folding --restow "${packages[@]}"

# hook the shared config into this machine's .bashrc (idempotent)
hook='[ -f ~/.config/bash/init.sh ] && . ~/.config/bash/init.sh  # dotfiles'
touch ~/.bashrc
grep -qxF "$hook" ~/.bashrc || echo "$hook" >> ~/.bashrc

echo " -> deployed: ${requested[*]}"
