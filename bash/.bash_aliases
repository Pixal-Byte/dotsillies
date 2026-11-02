# QoL aliases
alias reload='source ~/.bashrc'
alias ll='eza -lh'
alias lla='eza -lha'
alias la='eza -a'
alias s='kitten ssh'
alias bat='batcat'
alias ..='cd ..'
alias ff=fastfetch

#SSH aliases
alias sflux='s flux'
alias srelay='s relay'
alias sohm='s ohmlab'

# alias for yt-dlp audio extract
alias ad-yt-dlp='yt-dlp -t mp3 --embed-metadata --embed-thumbnail \
  --parse-metadata "%(track,title)s:%(meta_title)s" \
  --parse-metadata "%(artist,uploader)s:%(meta_artist)s" \
  --parse-metadata "%(album,playlist_title)s:%(meta_album)s" \
  -o "%(artist,uploader)s/%(album,playlist_title)s/%(track,title)s.%(ext)s"'

#python-related aliases
alias pyva='source .venv/bin/activate'
