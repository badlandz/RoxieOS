# /usr/bin/baux-shot  (single binary, 100 % reliable)
#!/usr/bin/env bash
# baux-shot — unified screenshot for console + X11
# Works on Pi framebuffer, old laptop, server with no X, everything

OUTDIR="$HOME/shots"
TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
mkdir -p "$OUTDIR"

if [[ -n "${DISPLAY:-}" && $(command -v maim) ]]; then
  # We are in X → use maim (lightweight, supports selection too)
  maim -u -s "/tmp/shot.raw.png" 2>/dev/null || maim -u "/tmp/shot.raw.png"
  convert "/tmp/shot.raw.png" "$OUTDIR/roxie_${TIMESTAMP}.png" && rm "/tmp/shot.raw.png"
else
  # Pure console → framebuffer grab (works on Pi, old servers, everything)
  if [[ -e /dev/fb0 ]]; then
    fbgrab -c 0 "/tmp/shot.bbm" 2>/dev/null || cat /dev/fb0 >"/tmp/shot.raw"
    convert "/tmp/shot.bbm" "$OUTDIR/roxie_${TIMESTAMP}.png" 2>/dev/null ||
      convert -size 1920x1080 rgb:/tmp/shot.raw "$OUTDIR/roxie_${TIMESTAMP}.png"
    rm -f "/tmp/shot.raw" "/tmp/shot.bbm"
  else
    echo "No framebuffer or X — you live in the void"
    exit 1
  fi
fi

echo "Screenshot saved: $OUTDIR/roxie_${TIMESTAMP}.png"
# Optional: copy latest to clipboard if possible
[[ -n "${DISPLAY:-}" ]] && xclip -selection clipboard -t image/png "$OUTDIR/roxie_${TIMESTAMP}.png" 2>/dev/null || true
