# Repository Guidelines

## Project Structure & Module Organization
- `config/hypr/`: Hyprland core config (binds, variables, styles, wallpapers, helper scripts).
- `config/eww/`: EWW widgets (`*.yuck`) and styles (`*.scss`, assets, scripts).
- `config/waybar/`, `config/rofi/`, `config/foot/`, etc.: App-specific configs and themes.
- `config/themes/`: Complete theme packs (Hypr, Waybar, Rofi, Wiremix, Foot, Fish).
- `scripts/`: Utility scripts used by install and maintenance.
- `install.sh`: Arch-based automated installer.
- `preview/`: GIFs/screenshots used in docs and PRs.

## Build, Test, and Development Commands
- `./install.sh`: Install dependencies, deploy configs, enable services (Arch-based).
- `hyprctl reload`: Reload Hyprland after editing files in `config/hypr/`.
- `pkill waybar && waybar &`: Restart Waybar; `eww daemon && eww reload` for EWW.
- `bash ~/.config/hypr/scripts/rofilaunch.sh --menu`: Test launchers/menus.
- Local iterate: symlink `config/*` to `~/.config/` and reload; avoid clobbering.

## Coding Style & Naming Conventions
- Shell: Bash with `set -euo pipefail`; lowercase-dashed filenames; use `.sh` when possible.
- Hyprland: `.conf` files; mirror existing spacing and section headers; concise comments.
- EWW/Waybar/Rofi: 2-space indent; keep related blocks grouped; `.yuck`, `.scss`/`.css`, `.rasi`.
- Scripts: idempotent, side-effect aware; avoid hardcoded user paths.

## Testing Guidelines
- No unit tests; use manual validation:
  - `hyprctl reload` completes without errors; check `journalctl --user -u hyprland` if applicable.
  - Bars/widgets render and toggle correctly; keybinds function.
  - Themes apply consistently across Hypr, Waybar, Rofi, Wiremix, Foot, Fish.

## Commit & Pull Request Guidelines
- Commits: short, imperative, Title Case; optional scope.
  - Examples: `hypr: add workspace binds`, `theme(purple): tweak waybar colors`.
- PRs: clear description, before/after screenshots or GIFs (use `preview/`), steps to verify, affected apps/themes; link issues when relevant.
- Update docs when adding themes or user-facing changes (README, previews).

## Security & Configuration Tips
- Do not commit secrets or machine-specific files.
- Keep local overrides outside the repo and source them from user configs when needed.
