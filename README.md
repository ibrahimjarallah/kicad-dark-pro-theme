# KiCad Dark Pro Theme

A professional dark gray compact UI theme for KiCad 10 on Linux — cleaner and more compact than Altium Designer's default layout.

Built and tested on **Arch Linux + Hyprland (Wayland)** with HyDE/wallbash rice management.

![KiCad Dark Pro Theme](screenshots/preview.png)

---

## Features

- **Pure dark gray** — no blue/purple color accents from desktop themes
- **Compact rectangular UI** — no rounded corners, minimal padding on all widgets
- **Scaled at 85% DPI** — smaller toolbars, sidebars, and status bar
- **Scrollable dropdowns** — long lists cap at 300px with scrollbar
- **Bypasses desktop theme enforcement** — works even with HyDE/wallbash, Catppuccin, or any GTK theme manager
- **Covers all KiCad tools** — main launcher, PCBnew, Eeschema, GerbView, PCB Calculator, Image Converter

---

## Requirements

- KiCad 10.x
- Linux with GTK3
- Wayland compositor (Hyprland, Sway, GNOME Wayland, KDE Wayland)
- `adwaita` GTK theme installed (default on most distros)

---

## Installation

### Automatic

```bash
git clone https://github.com/ibrahimxxxxxxx/kicad-dark-pro-theme.git
cd kicad-dark-pro-theme
chmod +x install.sh
./install.sh
```

### Manual

```bash
# 1. Copy wrappers
cp wrappers/* ~/.local/bin/
chmod +x ~/.local/bin/*-dark

# 2. Copy desktop entries (replace $HOME with your actual home path)
sed "s|\$HOME|$HOME|g" desktop/org.kicad.kicad.desktop > ~/.local/share/applications/org.kicad.kicad.desktop
sed "s|\$HOME|$HOME|g" desktop/org.kicad.eeschema.desktop > ~/.local/share/applications/org.kicad.eeschema.desktop
sed "s|\$HOME|$HOME|g" desktop/org.kicad.pcbnew.desktop > ~/.local/share/applications/org.kicad.pcbnew.desktop
sed "s|\$HOME|$HOME|g" desktop/org.kicad.gerbview.desktop > ~/.local/share/applications/org.kicad.gerbview.desktop
sed "s|\$HOME|$HOME|g" desktop/org.kicad.pcbcalculator.desktop > ~/.local/share/applications/org.kicad.pcbcalculator.desktop
sed "s|\$HOME|$HOME|g" desktop/org.kicad.bitmap2component.desktop > ~/.local/share/applications/org.kicad.bitmap2component.desktop

# 3. Install GTK CSS (backs up existing)
cp ~/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css.bak 2>/dev/null || true
cp gtk/gtk.css ~/.config/gtk-3.0/gtk.css
```

---

## How It Works

### The core problem
On Linux with HyDE, Catppuccin, or any GTK theme manager, KiCad inherits the system GTK theme (e.g. Catppuccin Mocha — blue/purple) via `dconf`/`gsettings` at runtime. There is no KiCad setting to override this.

### The fix
Each KiCad tool is launched via a wrapper script that exports `GTK_THEME=Adwaita:dark` at the **process level**, before KiCad starts. This bypasses `dconf`/`gsettings` entirely — the env var takes precedence over any system theme.

```bash
export GTK_THEME=Adwaita:dark          # bypass dconf/gsettings
export GTK_APPLICATION_PREFER_DARK_THEME=1
export GDK_BACKEND=wayland             # explicit Wayland backend
export GDK_DPI_SCALE=0.85             # compact UI scaling
```

### What NOT to do
| Approach | Why it fails |
|---|---|
| `gsettings set gtk-theme Adwaita` in wrapper | HyDE/dconf overwrites it at runtime |
| `unset GTK_THEME` | dconf Catppuccin then wins |
| `gtk.css` color overrides | Conflicts with Adwaita:dark, re-introduces accent colors |
| Kvantum env vars | Ignored at runtime for GTK3 apps |
| `userprefs.conf` border override | HyDE re-applies theme.conf after reload |

### GTK CSS scope
The `gtk.css` file only targets **geometry and padding** — no color rules. This is intentional. Color rules in `gtk.css` conflict with `Adwaita:dark` and re-introduce unwanted accent colors.

---

## File Structure

```
kicad-dark-pro-theme/
├── README.md
├── install.sh
├── wrappers/
│   ├── kicad-dark
│   ├── eeschema-dark
│   ├── pcbnew-dark
│   ├── gerbview-dark
│   ├── pcb_calculator-dark
│   └── bitmap2component-dark
├── desktop/
│   ├── org.kicad.kicad.desktop
│   ├── org.kicad.eeschema.desktop
│   ├── org.kicad.pcbnew.desktop
│   ├── org.kicad.gerbview.desktop
│   ├── org.kicad.pcbcalculator.desktop
│   └── org.kicad.bitmap2component.desktop
├── gtk/
│   └── gtk.css
└── screenshots/
```

---

## Compatibility

| Distro | Compositor | Status |
|---|---|---|
| Arch Linux | Hyprland (Wayland) | ✅ Tested |
| Arch Linux | Sway (Wayland) | ✅ Should work |
| Ubuntu / Debian | GNOME Wayland | ✅ Should work |
| Any | X11 | ⚠ Change `GDK_BACKEND=wayland` to `GDK_BACKEND=x11` in wrappers |

---

## KiCad Internal Settings

Apply these inside KiCad for best results:

```
Preferences → Common → User Interface:
  - Toolbar icon size: Small
  - Theme: Dark
```

---

## Panel Workflow (1366×768 and small displays)

Keep all side panels closed by default. Toggle only when needed:

| Panel | Hotkey (assign in Preferences → Hotkeys) |
|---|---|
| Appearance | `A` |
| Net Inspector | `N` |
| Search | `Ctrl+F` |
| Properties | `E` (inline) |

---

## License

MIT — free to use, modify, and distribute.

---

## Author

Ibrahim — Mechatronics Engineer, KiCad PCB Designer  
Arch Linux + Hyprland + HyDE
