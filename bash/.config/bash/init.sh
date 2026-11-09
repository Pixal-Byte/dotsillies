# sourced from ~/.bashrc (which stays untracked / per-machine)

#adding newly created, or already existent, "$HOME/.local/bin" to path
case ":$PATH:" in
	*":$HOME/.local/bin:"*) ;;
	*) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# initializing aliases and integrations
d="$HOME/.config/bash"
for f in aliases.sh integrations.sh; do
  [ -f "$d/$f" ] && . "$d/$f"
done
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"   # host-specific stuff
unset d f
