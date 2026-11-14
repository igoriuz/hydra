#!/bin/bash
# Renders the showcase animation used in the README to .github/demo.gif.
# Needs ffmpeg. Run from anywhere: example/tool/record_demo.sh
set -euo pipefail
cd "$(dirname "$0")/.."

frames=build/demo_frames
rm -rf "$frames"
FRAMES_DIR="$PWD/$frames" flutter test tool/record_demo.dart

ffmpeg -loglevel error -y -framerate 20 -i "$frames/frame_%04d.png" \
  -vf "scale=960:-1:flags=lanczos,split[a][b];[a]palettegen=stats_mode=diff[p];[b][p]paletteuse=dither=sierra2_4a:diff_mode=rectangle" \
  ../.github/demo.gif
ls -lh ../.github/demo.gif
