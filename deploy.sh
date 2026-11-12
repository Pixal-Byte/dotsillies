#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

# usage: ./deploy.sh [package...]   (default: bash starship)
requested=("$@")
[ ${#requested[@]} -eq 0 ] && requested=(bash starship)

#verifying if stow exists
command -v stow >/dev/null || { echo "install stow first"; exit 1; }

#persisting required directories
mkdir -p "$HOME/.local/bin"

#verifing if gitui is already installed or not.
if [[ " ${requested[*]} " == *" gitui "*  ]] && [ ! -e "$HOME/.local/bin/gitui" ]; then
	[ -f bin/gitui ] || { echo "bin/gitui missing from repo" >&2; exit 1; }
	echo "=== No gitui binary found already installed. copying from ./bin==="
	install -m 755 bin/gitui/gitui "$HOME/.local/bin/gitui"
fi

#building stow list
stow_pkgs=()
for p in "${requested[@]}"; do
	if [ -d "$p" ]; then
		stow_pkgs+=("$p")
	fi
done

# --no-folding keeps real directories, so untracked files in ~/.config/kitty
# etc. don't end up inside the repo
# guared the stow_pkgs array to not fail the stow command
if [ ${#stow_pkgs[@]} -gt 0 ]; then
	stow -t "$HOME" --no-folding --restow "${stow_pkgs[@]}"
fi

# hook the shared config into this machine's .bashrc (idempotent)
hook='[ -f ~/.config/bash/init.sh ] && . ~/.config/bash/init.sh  # dotfiles'
touch ~/.bashrc
grep -qxF "$hook" ~/.bashrc || echo "$hook" >> ~/.bashrc

echo " -> deployed: ${requested[*]}"
