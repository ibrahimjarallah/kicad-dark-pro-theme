#!/bin/bash
# ============================================================
# KiCad Dark Pro Theme — Install Script
# https://github.com/ibrahimxxxxxxx/kicad-dark-pro-theme
# Tested on: KiCad 10.0.1-2, Arch Linux, Hyprland, Wayland
# ============================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"
GTK_DIR="$HOME/.config/gtk-3.0"

echo "==> KiCad Dark Pro Theme Installer"
echo ""

# ── 1. Create directories ──
mkdir -p "$BIN_DIR" "$APP_DIR" "$GTK_DIR"

# ── 2. Install wrappers ──
echo "[1/3] Installing wrappers to $BIN_DIR ..."
for wrapper in "$REPO_DIR"/wrappers/*; do
    name="$(basename "$wrapper")"
    cp "$wrapper" "$BIN_DIR/$name"
    chmod +x "$BIN_DIR/$name"
    echo "      ✔ $name"
done

# ── 3. Install desktop entries ──
echo "[2/3] Installing desktop entries to $APP_DIR ..."
for desktop in "$REPO_DIR"/desktop/*.desktop; do
    name="$(basename "$desktop")"
    # Replace $HOME placeholder with actual home path
    sed "s|\$HOME|$HOME|g" "$desktop" > "$APP_DIR/$name"
    echo "      ✔ $name"
done

# Update desktop database
update-desktop-database "$APP_DIR" 2>/dev/null || true

# ── 4. Install GTK CSS ──
echo "[3/3] Installing GTK CSS to $GTK_DIR/gtk.css ..."
if [ -f "$GTK_DIR/gtk.css" ]; then
    cp "$GTK_DIR/gtk.css" "$GTK_DIR/gtk.css.bak"
    echo "      ℹ  Existing gtk.css backed up to gtk.css.bak"
fi
cp "$REPO_DIR/gtk/gtk.css" "$GTK_DIR/gtk.css"
echo "      ✔ gtk.css"

echo ""
echo "==> Installation complete."
echo "    Launch KiCad from your application menu or run: kicad-dark"
echo ""
echo "    NOTE: If you use a Wayland compositor other than Hyprland,"
echo "    you may need to adjust GDK_BACKEND in the wrappers."
