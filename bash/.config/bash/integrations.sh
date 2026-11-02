# ================== Shell Integrations =================================|
command -v starship >/dev/null && eval "$(starship init bash)"         # |
command -v zoxide   >/dev/null && eval "$(zoxide init bash)"           # |
command -v fzf      >/dev/null && eval "$(fzf --bash)"                 # | needs fzf 0.48+
# =======================================================================|