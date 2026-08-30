# Niri Dotfiles

Reviewed user configuration for the Niri-based desktop built by the companion
Arch Linux post-install repository.

## Project status

Bootstrap stage. The repository contains a small Niri package for proving that
the compositor can start and recover, plus one XDG autostart entry for the
reviewed removable-media service. It is not the final daily-driver
configuration.

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

## Current bootstrap

The current Stow packages own two files:

```text
niri/.config/niri/config.kdl
autostart/.config/autostart/udiskie.desktop
```

They provide only:

- the MATE polkit authentication-agent autostart;
- `Super+Enter` to open Kitty;
- `Super+Shift+E` to exit Niri through its confirmation dialog.
- automatic removable-media mounting through udiskie, without notifications or
  a tray icon at this stage.

It deliberately does not configure outputs, scaling, keyboard layout, themes,
bars, launchers, notifications, wallpaper, locking, idle handling, or
automatic login.

Package installation and the complete deployment procedure are documented in
[chapter 05 of Arch Linux Post-install](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/05-minimal-graphical-bootstrap.md).
The removable-media service is added in
[chapter 07](https://github.com/CycloniteRDX/arch-linux-post-install/blob/main/docs/07-core-workstation-services.md).

## Deploy with GNU Stow

From the repository root, preview the links:

```bash
stow --simulate --verbose --no-folding --target="$HOME" niri
stow --simulate --verbose --no-folding --target="$HOME" autostart
```

If the preview reports no conflict, deploy them:

```bash
stow --verbose --no-folding --target="$HOME" niri
stow --verbose --no-folding --target="$HOME" autostart
niri validate
```

Do not overwrite an existing `~/.config/niri/config.kdl`. Review and back up an
existing target before deploying this package.

Remove only the links owned by this package with:

```bash
stow --delete --verbose --target="$HOME" niri
stow --delete --verbose --target="$HOME" autostart
```

## Related repositories

- [Arch Linux Post-install](https://github.com/CycloniteRDX/arch-linux-post-install)
  installs the required desktop stack.
- [Arch Linux Handbook](https://github.com/CycloniteRDX/arch-linux-handbook)
  explains the components and troubleshooting.
- [Arch Linux Runbook](https://github.com/CycloniteRDX/arch-linux-runbook)
  installs the base system.
