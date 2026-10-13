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

# ytp "URL" -> stream in IINA via system yt-dlp + cookies, VP9 (hardware decode on M2), no download
ytp() {
  local -a ck
  _ytc && [[ -f $REPLY ]] && ck=("--mpv-ytdl-raw-options=cookies=$REPLY")
  iina --no-stdin "$1" \
    --mpv-script-opts=ytdl_hook-ytdl_path=/opt/homebrew/bin/yt-dlp \
    --mpv-ytdl-format="bv*[vcodec^=vp9][dynamic_range=SDR]+ba/bv*[vcodec^=avc1]+ba/b" \
    "${ck[@]}"
}
