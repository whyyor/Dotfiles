# ytcookies -> (re)set the cookies.txt path used by ytd/ytp
ytcookies() {
  local p
  read -r "p?YouTube cookies.txt path: "
  p=${p/#\~/$HOME}
  [[ -f $p ]] || { echo "ytcookies: '$p' not found"; return 1; }
  mkdir -p ~/.config/yt && print -r -- "${p:A}" > ~/.config/yt/cookies
}

# sets REPLY to the saved cookies path, prompting on first use
_ytc() {
  [[ -s ~/.config/yt/cookies ]] || ytcookies || return
  REPLY=$(<~/.config/yt/cookies)
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

# ytp [-4k] "URL" -> stream in IINA; default H.264 (hardware decode on M2, max 1080p), -4k = VP9 software decode
ytp() {
  local fmt="bv*[vcodec^=avc1][dynamic_range=SDR]+ba[ext=m4a]/b[vcodec^=avc1]/b"
  [[ $1 == -4k ]] && { fmt="bv*[vcodec^=vp9][dynamic_range=SDR]+ba/$fmt"; shift; }
  local -a ck
  _ytc && [[ -f $REPLY ]] && ck=("--mpv-ytdl-raw-options=cookies=$REPLY")
  iina --no-stdin "$1" \
    --mpv-script-opts=ytdl_hook-ytdl_path=/opt/homebrew/bin/yt-dlp \
    --mpv-hwdec=videotoolbox \
    --mpv-ytdl-format="$fmt" \
    "${ck[@]}"
}
