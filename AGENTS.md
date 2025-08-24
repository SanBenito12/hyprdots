# Repository Guidelines

## Project Structure & Module Organization
- `config/hypr/`: Hyprland core config (binds, variables, styles, wallpapers, helper scripts).
- `config/eww/`: EWW widgets (`*.yuck`) and styles (`*.scss`), assets, scripts.
- `config/waybar/`, `config/rofi/`, `config/foot/`, etc.: App-specific configs and themes.
- `config/themes/`: Complete theme packs (Hypr, Waybar, Rofi, Wiremix, Foot, Fish).
- `scripts/`: Utility scripts for install and maintenance.
- `install.sh`: Arch-based automated installer.
- `preview/`: GIFs/screenshots for docs and PRs.

## Build, Test, and Development Commands
- `./install.sh`: Install dependencies, deploy configs, enable services (Arch-based).
- Local iterate: symlink `config/*` to `~/.config/` to avoid clobbering.
- Reload Hyprland: `hyprctl reload`.
- Restart Waybar: `pkill waybar && waybar &`.
- Reload EWW: `eww daemon && eww reload`.
- Test launchers/menus: `bash ~/.config/scripts/rofilaunch.sh --menu`.

## Coding Style & Naming Conventions
- Shell: Bash with `set -euo pipefail`; lowercase-dashed filenames; prefer `.sh`.
- Hyprland: `.conf` files; mirror existing spacing and section headers; keep comments concise.
- EWW/Waybar/Rofi: 2-space indent; group related blocks; use `.yuck`, `.scss/.css`, `.rasi`.
- Scripts: idempotent and side-effect aware; avoid hardcoded user paths.

## Testing Guidelines
- Manual validation: `hyprctl reload` completes without errors; bars/widgets render and toggle; keybinds function.
- Theming: ensure colors/fonts apply consistently across Hypr, Waybar, Rofi, Wiremix, Foot, Fish.
- Troubleshooting: check `journalctl --user -u hyprland` when applicable.

## Commit & Pull Request Guidelines
- Commits: short, imperative, Title Case; optional scope.
  - Examples: `hypr: add workspace binds`, `theme(purple): tweak waybar colors`.
- PRs: include clear description, steps to verify, affected apps/themes; link issues; attach before/after screenshots or GIFs in `preview/`; update docs for user-facing changes.

## Security & Configuration Tips
- Do not commit secrets or machine-specific files.
- Keep local overrides outside the repo and source them from user configs when needed.
