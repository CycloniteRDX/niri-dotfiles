# Niri Dotfiles

Reviewed user configuration for the Niri-based desktop built by the companion
Arch Linux post-install repository.

## Project status

Architecture stage. The desktop component stack and deployment method have not
yet been selected, so this repository does not contain real dotfiles yet.

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

The exact list will follow the component decisions made in
`arch-linux-post-install`.

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

## Related repositories

- [Arch Linux Post-install](https://github.com/CycloniteRDX/arch-linux-post-install)
  installs the required desktop stack.
- [Arch Linux Handbook](https://github.com/CycloniteRDX/arch-linux-handbook)
  explains the components and troubleshooting.
- [Arch Linux Runbook](https://github.com/CycloniteRDX/arch-linux-runbook)
  installs the base system.
