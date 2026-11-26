# Spark render server (the office Mac Studio, user wishtalesai): what the Wishtales mobile server's Story Mode,
# Spark sketch reveal and math mode need from Homebrew. Only applied on that machine; the MacBook already gets
# ffmpeg (with libass) from the homebrew-ffmpeg tap in homebrew.nix, and two linked ffmpegs would collide.
{ lib, user, ... }:
lib.mkIf (user == "wishtalesai") {
  homebrew.brews = [
    "node"          # the server runs on Homebrew's node (first on PATH)
    "yt-dlp"        # Story Mode style references: YouTube / Instagram / TikTok downloads
    # plain "ffmpeg" ships without libass and drawtext (captions and title cards fail); -full is keg-only, so link it
    # into /opt/homebrew/bin, where the server's FFMPEG_PATH points
    { name = "ffmpeg-full"; link = "overwrite"; }
    # tools/python/.venv (OpenCV sketch engine, manim): python 3.12 for the pinned numpy, cairo + pkgconf + pango for
    # pycairo / manimpango. One-time after a switch, in 04_Wishtales_for_Mobile/server/tools/python:
    #   /opt/homebrew/bin/python3.12 -m venv .venv && .venv/bin/pip install -r requirements.txt
    "python@3.12"
    "cairo"
    "pkgconf"
    "pango"
  ];
}
