#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

# usage: ./deploy.sh [package...]   (default: bash starship)
packages=("$@")
[ ${#packages[@]} -eq 0 ] && packages=(bash starship)

command -v stow >/dev/null || { echo "install stow first"; exit 1; }

# --no-folding keeps real directories, so untracked files in ~/.config/kitty
# etc. don't end up inside the repo
stow --no-folding --restow "${packages[@]}"

# hook the shared config into this machine's .bashrc (idempotent)
hook='[ -f ~/.config/bash/init.sh ] && . ~/.config/bash/init.sh  # dotfiles'
touch ~/.bashrc
grep -qxF "$hook" ~/.bashrc || echo "$hook" >> ~/.bashrc

echo "deployed: ${packages[*]}"