# Niri Dotfiles

Reviewed user configuration for the Niri-based desktop built by the companion
Arch Linux post-install repository.

## Project status

Portable daily-driver stage. The repository contains the reviewed Niri desktop,
removable-media autostart, default-application map, bar, launcher, notification
daemon, wallpaper location, screen-locker configuration, idle lifecycle, and
Kitty terminal configuration. It also contains the portable Midnight Circuit
visual foundation: a project-owned wallpaper, one shared dark palette, GTK
preferences, Papirus icons, the Breeze cursor theme, and a matching Qt 6
widget palette through qt6ct and Fusion.
The underlying baseline passed the complete post-install validation on the
first target ThinkPad on 2026-09-04, and the Qt 6 extension passed its own
hardware validation on 2026-09-05. The battery-only automatic-suspend
extension also passed hardware validation on 2026-09-05 after its helper's
executable bit was corrected in `post-install-18-v2`. Host-specific output
settings and later modular polish remain intentionally unfinished.

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
- a compact status bar, launcher, and notification presentation.
- immediate and idle-triggered locking, monitor power control, and pre-suspend
  lock coordination.
- battery-only automatic suspend after 30 idle minutes, through a fail-closed
  UPower helper that preserves systemd inhibitors;
- complete portable Niri navigation, movement, sizing, workspace, floating, and
  tabbed-layout bindings;
- a reproducible Midnight Circuit palette using Noto Sans and Noto Sans Mono;
- a project-owned SVG wallpaper with a solid-colour fallback;
- dark GTK preferences, Papirus Dark icons, and the Breeze cursor theme;
- Qt 6 widget fonts, icons, dialogs, Fusion style, and a custom Midnight
  Circuit palette through qt6ct.

It deliberately does not configure outputs, scaling, Qt 5, Kvantum, a forced
Qt platform backend, automatic suspend on AC, hibernation, or automatic login.
The portable baseline currently sets the XKB layout to `us`; a future
host-override design may replace that shared choice per machine. The qt6ct
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
deployed.

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
test -x "$HOME/.local/bin/idle-suspend"
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
```

## Related repositories

- [Arch Linux Post-install](https://github.com/CycloniteRDX/arch-linux-post-install)
  installs the required desktop stack.
- [Arch Linux Handbook](https://github.com/CycloniteRDX/arch-linux-handbook)
  explains the components and troubleshooting.
- [Arch Linux Runbook](https://github.com/CycloniteRDX/arch-linux-runbook)
  installs the base system.
