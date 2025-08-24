# Repository Guidelines

## Project Structure & Module Organization
- `config/hypr/`: Hyprland core config, binds, variables, styles, wallpapers, and helper scripts.
- `config/eww/`: EWW widgets (`*.yuck`) and styles (`*.scss`, assets, scripts).
- `config/waybar/`, `config/rofi/`, `config/foot/`, etc.: App-specific configs and themes.
- `config/themes/`: Complete theme packs (Hypr, Waybar, Rofi, Wiremix, Foot, Fish).
- `scripts/`: Utility scripts used by the setup and maintenance flow.
- `install.sh`: Arch-based automated installer; installs deps and deploys configs.
- `preview/`: GIFs/screenshots for docs and PRs.

## Build, Test, and Development Commands
- Install (Arch-based): `./install.sh` (runs dependency install, copies configs, enables services).
- Reload Hyprland: `hyprctl reload` (apply config changes without logging out).
- Restart bars/widgets: `pkill waybar && waybar &` • `eww daemon && eww reload`.
- Test launchers/menus: `bash ~/.config/hypr/scripts/rofilaunch.sh --menu`.
- Local iterate (no installer): copy or symlink `config/*` into `~/.config/`, then reload.

## Coding Style & Naming Conventions
- Shell: Bash, `set -euo pipefail`; lowercase-dashed names, prefer `.sh` (unless tool expects none).
- Hyprland: `.conf` files; mirror existing spacing and section headers; keep comments concise.
- EWW/Rofi/Waybar: `.yuck`, `.scss`/`.css`, `.rasi`; 2-space indent; group related blocks.
- Keep scripts idempotent and side-effect aware; avoid hardcoding user-specific paths.

## Testing Guidelines
- No unit tests; use manual validation:
  - Hypr reloads cleanly (no errors in `journalctl --user -u hyprland` if applicable).
  - Bars/widgets render and toggle correctly; keybinds function.
  - Themes apply across Hypr, Waybar, Rofi, Wiremix, Foot consistently.
- Prefer temporary symlinks in `~/.config/` during development to avoid clobbering.

## Commit & Pull Request Guidelines
- Commits: short imperative/title case summaries; optional scope prefix.
  - Examples: `hypr: add workspace binds`, `theme(purple): tweak waybar colors`.
- PRs: clear description, before/after screenshots or GIFs (use `preview/`), steps to verify, and affected apps/themes.
- Update docs when adding themes or user-facing changes (README, previews).

## Security & Configuration Tips
- Do not commit secrets or machine-specific files. Keep overrides in local files outside the repo and source them from user configs if needed.
