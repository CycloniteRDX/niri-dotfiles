# Niri Dotfiles

Reviewed user configuration for the Niri-based desktop built by the companion
Arch Linux post-install repository.

## Project status

Validated first-target daily-driver stage. The repository contains the reviewed Niri desktop,
removable-media autostart, default-application map, bar, launcher, notification
daemon, wallpaper location, screen-locker configuration, idle lifecycle, and
Kitty terminal configuration. It also contains the portable Midnight Circuit
visual foundation: a project-owned wallpaper, one shared dark palette, GTK
preferences, Papirus icons, the Breeze cursor theme, and a matching Qt 6
widget palette through qt6ct and Fusion.
The underlying baseline passed the complete post-install validation on the
first target ThinkPad on 2026-09-04, and the Qt 6, automatic-suspend, Plymouth,
and TPM2 extensions passed their separate hardware validations. Chapter 21's
compact, icon-led Waybar passed hardware validation on 2026-09-07; its required
icon fonts are `otf-font-awesome` and
`ttf-nerd-fonts-symbols-mono`. Chapter 22 records the same target's finished
Niri v1 configuration and its event-driven TLP profile-to-refresh integration,
also hardware-validated on 2026-09-07. The exact internal-panel policy is
specific to this first measured ThinkPad; the second machine still requires
its own output record before this checkpoint is reused there.

Chapter 23 records the reviewed personalization of Kitty, Mako, Fuzzel, and
swaylock, plus explicit monitor restoration after a system resume. The complete
set passed hardware validation on the first ThinkPad on 2026-09-08. After the
matching documentation commits, `post-install-23-v1` was created as the
cumulative checkpoint in both the dotfiles and post-install repositories.

Chapter 25 records four subsequent, independently committed packages for Bash,
Nano, Micro, and Vim. Their syntax, JSON, link, state-directory, clipboard, and
real-editor behavior passed validation on the first ThinkPad on 2026-09-08.
After the matching documentation commits, `post-install-25-v1` was created as
the cumulative checkpoint in both repositories. Chapter 24 is intentionally a
post-install-only tag because tuigreet is system configuration outside this
repository. Chapter 26 is likewise post-install-only: the validated RogueOS
Plymouth theme is system-owned and introduces no dotfiles package.

## Scope

This repository will own user-level configuration for components such as:

- Niri.
- Terminal emulator.
- Application launcher.
- Status bar or shell components.
- Notification daemon.
- Screen locker and idle manager.
- Wallpaper tooling.
- Screenshot and color-picker tools.
- Theme, GTK, cursor, and icon settings.
- Selected command-line and graphical applications.

The exact list follows the component decisions made in
`arch-linux-post-install`. Kitty is the canonical terminal; the remaining
desktop roles are added only after they have been reviewed.

## Boundary

This repository does not install the operating system or own system services.
Package installation, service enablement, permissions, portals, polkit rules,
and other machine-level changes belong in the post-install repository.

## Security rules

The following material must never be committed:

- Passwords, access tokens, and API keys.
- SSH private keys.
- Secure Boot private keys.
- Browser profiles and session cookies.
- Wi-Fi credentials.
- Secret-store contents.
- Machine-specific identifiers that are not required by a public example.

Secret values should be injected by a documented external mechanism. Public
example files may use clearly fake placeholders.

## Reproducibility rules

- Keep configuration paths recognizable relative to the user home directory.
- Prefer symlinks or a reviewed dotfile manager over copying files blindly.
- Back up an existing target before replacing it.
- Separate portable configuration from host-specific overrides.
- Make deployment idempotent where practical.
- Validate configuration before restarting a session.
- Document required packages in the post-install repository, not in an
  unstructured shell script here.

## Planned structure

See the [dotfiles design notes](docs/README.md).

The design notes also define the immutable
[post-install checkpoints](docs/README.md#post-install-checkpoints). Use those
tags when following the companion guide chapter by chapter; `main` represents
the latest reviewed desktop and can contain components from later chapters.

## Current configuration

The current Stow packages own these areas:

```text
niri/.config/niri/config.kdl
niri/.config/niri/scripts/power-profile-refresh.py
autostart/.config/autostart/udiskie.desktop
mimeapps/.config/mimeapps.list
waybar/.config/waybar/{config.jsonc,style.css}
fuzzel/.config/fuzzel/fuzzel.ini
mako/.config/mako/config
wallpapers/.local/share/wallpapers/README.md
wallpapers/.local/share/wallpapers/ATTRIBUTION.md
wallpapers/.local/share/wallpapers/midnight-circuit.svg
swaylock/.config/swaylock/config
kitty/.config/kitty/kitty.conf
bash/.bash_profile
bash/.bashrc
nano/.config/nano/{nanorc,kdl.nanorc}
micro/.config/micro/settings.json
micro/.config/micro/colorschemes/rogueos.micro
micro/.config/micro/syntax/{kdl.yaml,kitty.yaml}
vim/.config/vim/vimrc
theme/.config/gtk-3.0/settings.ini
theme/.config/gtk-4.0/settings.ini
qt6ct/.config/qt6ct/qt6ct.conf
qt6ct/.config/qt6ct/colors/midnight-circuit.conf
scripts/.local/bin/idle-suspend
```

They provide:

- the MATE polkit authentication-agent autostart;
- `Super+Enter` to open Kitty;
- `Super+D` to open Fuzzel;
- `Super+Shift+E` to exit Niri through its confirmation dialog;
- Niri screenshot and hardware-key bindings;
- Waybar, Mako, and swaybg session startup;
- automatic removable-media mounting through udiskie, without notifications or
  a tray icon of its own;
- default handlers for web links, directories, documents, images, text, media,
  archives, calendar files, and office files;
- a compact full-width Midnight Circuit status bar with dynamic Niri workspace
  dots, a centered clock, and icon-led status modules;
- immediate and idle-triggered locking, monitor power control, and pre-suspend
  lock coordination;
- battery-only automatic suspend after 30 idle minutes, through a fail-closed
  UPower helper that preserves systemd inhibitors;
- the first target's finished Niri v1 input, navigation, movement, sizing,
  workspace, floating, tabbed-layout, overview, and recent-window behavior;
- event-driven switching of `eDP-1` between 60.049 Hz and 48.040 Hz from
  TLP's standard profile interface, with reapplication after resume;
- a reproducible Midnight Circuit palette using Noto Sans and Noto Sans Mono;
- a project-owned SVG wallpaper with a solid-colour fallback;
- dark GTK preferences, Papirus Dark icons, and the Breeze cursor theme;
- Qt 6 widget fonts, icons, dialogs, Fusion style, and a custom Midnight
  Circuit palette through qt6ct;
- a compact Fuzzel launcher with fzf-style matching, useful desktop-entry
  fields, a match counter, and overlay placement;
- Mako notification history, urgency-specific behavior, progress indication,
  mouse/touch actions, and Fuzzel-backed action selection;
- a smaller Midnight Circuit swaylock indicator with explicit authentication
  states;
- Kitty cursor trails, per-pixel touchpad scrollback, contextual tabs,
  clipboard/paste safeguards, command-finish notifications, and 94% background
  opacity;
- explicit monitor power-on after a system resume, in addition to the existing
  monitor-off timeout's activity-resume command.
- a compact Bash prompt with Git and failure state, bounded append-only history,
  prefix history search, completion preferences, and small navigation aliases;
- predictable Nano editing defaults, Arch's syntax collection, and a local KDL
  syntax definition for Niri configuration;
- Micro's RogueOS palette, editor behavior, external Wayland clipboard, and
  project-owned KDL and Kitty syntax definitions;
- a plugin-free Vim learning profile with persistent undo, isolated swap state,
  smart searching, RogueOS colors, and a `wl-clipboard` provider.

It deliberately does not configure external outputs, Qt 5, Kvantum, a forced
Qt platform backend, automatic suspend on AC, hibernation, or automatic login.
The current `eDP-1` mode and 1.25 scale are validated only for the first
target ThinkPad; they are not yet a portable two-machine policy. The
configuration sets the XKB layout to `us`, maps Caps Lock to Ctrl, and uses
right Alt as Compose. The qt6ct
palette path contains the canonical account `/home/neon`; adapt that single
line before deployment if the repository is reused under another user. greetd
and tuigreet are system configuration documented outside this user-level
repository.

Package installation and the complete deployment procedure are documented in
[chapter 05 of Arch Linux Post-install](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/05-minimal-graphical-bootstrap.md).
The removable-media service is added in
[chapter 07](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/07-core-workstation-services.md).
Daily applications and the default-handler map are added in
[chapter 09](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/09-daily-applications.md).
The visible desktop components are added in
[chapter 10](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/10-desktop-components.md).
Locking, idle handling, and login are added in
[chapter 11](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/11-login-lock-and-idle.md).
The portable daily-driver handoff and Kitty package are completed in
[chapter 13](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/13-full-dotfiles-handoff.md).
The visual foundation is deployed and verified in
[chapter 15](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/15-visual-foundation.md).
Qt 6 appearance is integrated separately in
[chapter 17](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/17-qt6-appearance-integration.md).
Battery-only automatic session suspend is added in
[chapter 18](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/18-automatic-session-suspend.md).
The first advanced personalization stage refines Waybar in
[chapter 21](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/21-waybar-visual-refinement.md).
That chapter installs and verifies the `Font Awesome 7 Free` and
`Symbols Nerd Font Mono` families required by the tracked Waybar CSS and
glyphs. Stow deploys the configuration files; it does not install those fonts.
The finished Niri v1 input, layout, binding, and adaptive-refresh policy is
recorded in
[chapter 22](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/22-niri-daily-driver-refinement.md).
That chapter makes `playerctl` and `python-gobject` explicit runtime
dependencies and documents why the internal-panel values are host-specific.
The current multi-component personalization stage is reviewed and tested in
[chapter 23](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/23-core-desktop-component-refinement.md).
It introduces no new package dependency and records the completed real-session,
lock, notification, terminal, and suspend/resume validation.
The Bash and terminal-editor packages are deployed and verified in
[chapter 25](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/25-terminal-shell-and-editor-refinement.md).
That chapter installs `nano-syntax-highlighting`, makes the existing Bash,
Nano, Micro, Vim, Git, and `wl-clipboard` dependencies explicit, creates Vim's
generated state directories, and preserves the user/system ownership boundary.

## Fresh installations after the desktop is stable

The chapter tags are cumulative snapshots, not migrations that must be applied
one after another. A later tag already contains the tracked state from its
ancestors.

- Use each chapter's exact `post-install-NN-vN` tag when learning, validating,
  reproducing an old checkpoint, or locating a regression.
- For a routine clean rebuild after the whole desktop is settled, complete the
  corresponding system-package and service procedure, select the newest
  hardware-validated dotfiles tag once, and deploy the required Stow packages.
- Do not use an unqualified moving `main` as the unattended reinstall source.
  `main` is appropriate for active development; a stable release tag records
  the exact reviewed reconstruction point.

Selecting the latest dotfiles tag does not install packages or system files.
The matching post-install state is still required before its configuration is
deployed. A target-specific tag must also match the measured machine: chapter
22 is ready for the first ThinkPad, while the second must verify its connector,
exact timings, and preferred scale before selecting it.

When the first fully personalized desktop is declared stable, publish a
semantic dotfiles release tag as the ordinary reinstall target and record the
matching post-install release beside it. Keep the numbered chapter tags for
teaching, diagnosis, and historical reproduction.

## Deploy with GNU Stow

From the repository root, preview the links:

```bash
stow --simulate --verbose --no-folding --target="$HOME" niri
stow --simulate --verbose --no-folding --target="$HOME" autostart
stow --simulate --verbose --no-folding --target="$HOME" mimeapps
stow --simulate --verbose --no-folding --target="$HOME" waybar fuzzel mako wallpapers
stow --simulate --verbose --no-folding --target="$HOME" swaylock
stow --simulate --verbose --no-folding --target="$HOME" kitty
stow --simulate --verbose --no-folding --target="$HOME" theme
stow --simulate --verbose --no-folding --target="$HOME" qt6ct
stow --simulate --verbose --no-folding --target="$HOME" scripts
stow --simulate --verbose --no-folding --target="$HOME" bash nano micro vim
```

If the preview reports no conflict, deploy them:

```bash
stow --verbose --no-folding --target="$HOME" niri
stow --verbose --no-folding --target="$HOME" autostart
stow --verbose --no-folding --target="$HOME" mimeapps
stow --verbose --no-folding --target="$HOME" waybar fuzzel mako wallpapers
stow --verbose --no-folding --target="$HOME" swaylock
stow --verbose --no-folding --target="$HOME" kitty
stow --verbose --no-folding --target="$HOME" theme
stow --verbose --no-folding --target="$HOME" qt6ct
stow --verbose --no-folding --target="$HOME" scripts
stow --verbose --no-folding --target="$HOME" bash nano micro vim
test -x "$HOME/.local/bin/idle-suspend"
test -x "$HOME/.config/niri/scripts/power-profile-refresh.py"
niri validate
```

Do not overwrite an existing `~/.config/niri/config.kdl` or
`~/.config/mimeapps.list`. Review and back up an existing target before
deploying its package.

Remove only the links owned by this package with:

```bash
stow --delete --verbose --target="$HOME" niri
stow --delete --verbose --target="$HOME" autostart
stow --delete --verbose --target="$HOME" mimeapps
stow --delete --verbose --target="$HOME" waybar fuzzel mako wallpapers
stow --delete --verbose --target="$HOME" swaylock
stow --delete --verbose --target="$HOME" kitty
stow --delete --verbose --target="$HOME" theme
stow --delete --verbose --target="$HOME" qt6ct
stow --delete --verbose --target="$HOME" scripts
stow --delete --verbose --target="$HOME" bash nano micro vim
```

## Related repositories

- [Arch Linux Post-install](https://github.com/CycloniteRDX/arch-linux-post-install)
  installs the required desktop stack.
- [Arch Linux Handbook](https://github.com/CycloniteRDX/arch-linux-handbook)
  explains the components and troubleshooting.
- [Arch Linux Runbook](https://github.com/CycloniteRDX/arch-linux-runbook)
  installs the base system.
