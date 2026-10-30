# ytcookies -> (re)set the cookies.txt path used by ytd/ytp
ytcookies() {
  local p junk
  while true; do
    p=
    { while read -t 0.05 -k 1 junk; do :; done; read -r "p?YouTube cookies.txt path (Enter = skip): "; } < /dev/tty  # drain typeahead, read from real terminal
    [[ -z $p ]] && { echo "ytcookies: skipped, continuing without cookies"; return 1; }
    p=${(Q)p}; p=${p/#\~/$HOME}  # strip quotes/escapes from drag-and-drop, expand ~
    [[ -f $p ]] && break
    echo "ytcookies: '$p' not found, try again"
  done
  mkdir -p ~/.config/yt && print -r -- "${p:A}" > ~/.config/yt/cookies
  echo "ytcookies: saved ${p:A}"
}

# sets REPLY to the saved cookies path; prompts if none saved or the saved file is gone
_ytc() {
  local f=~/.config/yt/cookies
  [[ -s $f && -f $(<$f) ]] || ytcookies || return
  REPLY=$(<$f)
}

# ytd "URL" -> 4K VP9 download, hardware HEVC re-encode for smooth playback on Apple Silicon
ytd() {
  local f; local -a ck
  _ytc && [[ -f $REPLY ]] && ck=(--cookies "$REPLY")
  f=$(yt-dlp "${ck[@]}" \
    -f "bv*[vcodec^=vp9][dynamic_range=SDR]+ba[ext=m4a]/bv*[vcodec^=avc1]+ba[ext=m4a]/b" \
    --merge-output-format mkv -o "%(title)s.src.%(ext)s" \
    --print after_move:filepath --no-simulate "$1") || return
  [[ -f $f ]] || { echo "ytd: download failed"; return 1; }
  ffmpeg -hide_banner -i "$f" -c:v hevc_videotoolbox -b:v 10M -tag:v hvc1 -c:a copy \
    -movflags +faststart "${f%.src.mkv}.mp4" && rm "$f"
}

# ytp [-4k] "URL" -> stream in IINA (launched via LaunchServices, detached + focused); default H.264 (hardware decode on M2, max 1080p), -4k = VP9 software decode
ytp() {
  local fmt="bv*[vcodec^=avc1][dynamic_range=SDR]+ba[ext=m4a]/b[vcodec^=avc1]/b"
  [[ $1 == -4k ]] && { fmt="bv*[vcodec^=vp9][dynamic_range=SDR]+ba/$fmt"; shift; }
  local -a ck
  _ytc && [[ -f $REPLY ]] && ck=("--mpv-ytdl-raw-options=cookies=$REPLY")
  open -na IINA --args "$1" \
    --mpv-script-opts=ytdl_hook-ytdl_path=/opt/homebrew/bin/yt-dlp \
    --mpv-hwdec=videotoolbox \
    --mpv-ytdl-format="$fmt" \
    "${ck[@]}"
}
