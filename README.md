# Niri Dotfiles

Reviewed user configuration for the Niri-based desktop built by the companion
Arch Linux post-install repository.

## Project status

Portable daily-driver stage. The repository contains the reviewed Niri desktop,
removable-media autostart, default-application map, bar, launcher, notification
daemon, wallpaper location, screen-locker configuration, idle lifecycle, and
Kitty terminal configuration.
Themes and host-specific output settings remain intentionally unfinished.

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
swaylock/.config/swaylock/config
kitty/.config/kitty/kitty.conf
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
- complete portable Niri navigation, movement, sizing, workspace, floating, and
  tabbed-layout bindings;
- a reproducible opaque Kitty palette using Noto Sans Mono.

It deliberately does not configure outputs, scaling, themes, automatic idle
suspend, hibernation, or automatic login. The portable baseline currently sets
the XKB layout to `us`; a future host-override design may replace that shared
choice per machine. greetd and tuigreet are system configuration documented
outside this user-level repository.

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

## Deploy with GNU Stow

From the repository root, preview the links:

```bash
stow --simulate --verbose --no-folding --target="$HOME" niri
stow --simulate --verbose --no-folding --target="$HOME" autostart
stow --simulate --verbose --no-folding --target="$HOME" mimeapps
stow --simulate --verbose --no-folding --target="$HOME" waybar fuzzel mako wallpapers
stow --simulate --verbose --no-folding --target="$HOME" swaylock
stow --simulate --verbose --no-folding --target="$HOME" kitty
```

If the preview reports no conflict, deploy them:

```bash
stow --verbose --no-folding --target="$HOME" niri
stow --verbose --no-folding --target="$HOME" autostart
stow --verbose --no-folding --target="$HOME" mimeapps
stow --verbose --no-folding --target="$HOME" waybar fuzzel mako wallpapers
stow --verbose --no-folding --target="$HOME" swaylock
stow --verbose --no-folding --target="$HOME" kitty
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
```

## Related repositories

- [Arch Linux Post-install](https://github.com/CycloniteRDX/arch-linux-post-install)
  installs the required desktop stack.
- [Arch Linux Handbook](https://github.com/CycloniteRDX/arch-linux-handbook)
  explains the components and troubleshooting.
- [Arch Linux Runbook](https://github.com/CycloniteRDX/arch-linux-runbook)
  installs the base system.
