# QoL aliases
alias reload='source ~/.bashrc'
alias ..='cd ..'

#gitui aliases
if command -v gitui --version >/dev/null; then
	alias gu='gitui'
fi

#trash-cli related aliases
if command -v trash-put >/dev/null; then
	alias tp='trash-put'
	alias tl='trash-list'
	alias te='trash-empty'
	alias tr='trash-restore'
fi

#eza's aliases
_eza_base='--icons --group-directories-first --git --color=always'
alias lta="eza $_eza_base -Ta --level=2"
alias lt="eza $_eza_base -T"
alias ll="eza $_eza_base -lh"
alias lla="eza $_eza_base -lha"
alias la="eza $_eza_base -a"
alias ls="eza $_eza_base"
unset _eza_base

#package dependent aliases
command -v fastfetch >/dev/null && alias ff=fastfetch
command -v batcat    >/dev/null && alias bat='batcat'
command -v batcat    >/dev/null && alias batrebuild='bat cache --build'
command -v eza       >/dev/null || alias ll='ls -lh'
command -v eza       >/dev/null || alias lla='ls -lha'
command -v eza       >/dev/null || alias la='ls -a'

#SSH aliases
alias s='kitten ssh'
alias sflux='s flux'
alias srelay='s relay'
alias sohm='s ohmlab'

# alias for yt-dlp audio extract (If yt-dlp exists.)
command -v yt-dlp >/dev/null && alias ad-yt-dlp='yt-dlp -t mp3 --embed-metadata --embed-thumbnail \
  --parse-metadata "%(track,title)s:%(meta_title)s" \
  --parse-metadata "%(artist,uploader)s:%(meta_artist)s" \
  --parse-metadata "%(album,playlist_title)s:%(meta_album)s" \
  -o "%(artist,uploader)s/%(album,playlist_title)s/%(track,title)s.%(ext)s"'

#python-related aliases
alias pyva='source .venv/bin/activate'
