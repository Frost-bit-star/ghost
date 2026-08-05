#!/data/data/com.termux/files/usr/bin/bash
# Ghost installer / updater for Termux.
# Replaces the installed ghost and VERIFIES the new build actually landed,
# so a failed download can never look like a successful "update".
#
# Usage on your phone:  bash install.sh

PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
DEST="$PREFIX/bin/ghost"
URL="https://raw.githubusercontent.com/Frost-bit-star/ghost/main/ghost/usr/bin/ghost"
TMP="$HOME/.ghost_install_tmp"

if [[ -z "$PREFIX" || ! -d "$PREFIX/bin" ]]; then
    echo "[!] Termux not detected (\$PREFIX/bin not found)."
    echo "    Run this inside Termux, or set PREFIX=/data/data/com.termux/files/usr"
    exit 1
fi

echo "[*] Installing ghost to $DEST"
if ! wget -q "$URL" -O "$TMP" 2>/dev/null && ! curl -sfL "$URL" -o "$TMP" 2>/dev/null; then
    echo "[!] Download failed - check your network (raw.githubusercontent.com may be blocked)."
    echo "    Fallback: fetch debs/ghost.deb from the repo and run: pkg reinstall ./ghost.deb"
    exit 1
fi

if [[ ! -s "$TMP" ]] || ! grep -q "TEAM PROTOCOL" "$TMP"; then
    echo "[!] Downloaded file is not the latest ghost build. Nothing was changed."
    rm -f "$TMP"
    exit 1
fi

if ! mv -f "$TMP" "$DEST" 2>/dev/null; then
    echo "[!] Cannot write to $DEST (permissions?)."
    rm -f "$TMP"
    exit 1
fi
chmod +x "$DEST"

NEWVER=$(grep '^GHOST_VERSION=' "$DEST" | head -n 1 | cut -d'"' -f2)
[[ -n "$NEWVER" ]] || NEWVER="(new build)"
echo "[OK] Ghost ${NEWVER} installed at $DEST"
echo "[i] Start it with:  ghost"
