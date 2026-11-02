# sourced from ~/.bashrc (which stays untracked / per-machine)
d="$HOME/.config/bash"
for f in aliases.sh integrations.sh; do
  [ -f "$d/$f" ] && . "$d/$f"
done
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"   # host-specific stuff
unset d f