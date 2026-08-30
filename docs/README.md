# Dotfiles design notes

## Repository layout

GNU Stow is the selected deployment method. Each top-level component directory
is a Stow package whose contents mirror paths relative to the user home
directory:

```text
.
├── README.md
├── docs/
├── autostart/
│   └── .config/
│       └── autostart/
│           └── udiskie.desktop
├── mimeapps/
│   └── .config/
│       └── mimeapps.list
└── niri/
    └── .config/
        └── niri/
            └── config.kdl
```

Future component packages, host overrides, scripts, or tests will be created
only when they contain reviewed files.

| Path | Intended role |
| --- | --- |
| `docs/` | Deployment, recovery, component map, and customization notes. |
| `autostart/` | Portable XDG autostart entries for reviewed session utilities. |
| `mimeapps/` | Portable XDG default-application associations. |
| `niri/` | Portable Niri files arranged relative to `$HOME` for GNU Stow. |
| `waybar/` | Niri-aware status bar configuration and CSS. |
| `fuzzel/` | Application-launcher configuration. |
| `mako/` | Notification presentation and urgency policy. |
| `wallpapers/` | Reviewed wallpaper assets or documentation. |
| `swaylock/` | Portable lock-screen appearance; authentication remains PAM-owned. |
| `kitty/` | Portable terminal behavior and palette without shell state or secrets. |
| Future component package | One independently deployable application or coherent configuration group. |
| Future `hosts/` | Small, non-secret overrides for hardware-specific differences. |
| Future `scripts/` | Narrow deployment or validation helpers, only when they reduce mistakes. |
| Future `tests/` | Safe syntax and link checks that do not require a running graphical session. |

Using separate Stow packages keeps deployment explicit. For example, adding a
future Kitty package will not require deploying a launcher, bar, or theme at
the same time.

`--no-folding` is used during deployment so Stow creates a link for the tracked
file instead of replacing the whole `~/.config/niri` directory with one folded
directory symlink. This leaves the target structure easy to inspect and makes
future non-Stow files or host-specific composition less surprising.

## Current bootstrap contract

The chapter 05 Niri package must remain small enough to audit from TTY. It may
contain only:

- the graphical polkit agent autostart required by the session foundation;
- a binding that opens Kitty;
- a binding that exits Niri through its normal confirmation dialog.

It must not hard-code:

- an output name, resolution, refresh rate, or scale;
- `DISPLAY` or a manual `xwayland-satellite` process;
- paths containing a user name or machine identifier;
- a greeter, lock screen, bar, launcher, notification daemon, or shell.

The absence of manual XWayland configuration is intentional. Current Niri
integrates `xwayland-satellite` on demand and exports `DISPLAY` itself.

Chapter 07 adds an independent `autostart` Stow package. Its single desktop
entry starts udiskie with automatic mounting enabled and notifications disabled
until the notification daemon is selected. Keeping it separate avoids making a
generic session utility part of the compositor configuration.

Chapter 09 adds an independent `mimeapps` Stow package. It records only the
reviewed default desktop-file IDs for URLs and common local file types. It does
not contain recent-file history, browser state, credentials, or generated
application caches. An application's **Make default** action may edit this
tracked file through the deployed symlink, so every such change must be
reviewed with Git.

Chapter 10 advances the Niri package beyond its bootstrap contract. Niri starts
Waybar, Mako, and swaybg and owns launcher, screenshot, hardware-key, and exit
bindings. Waybar, Fuzzel, and Mako remain independent Stow packages. Niri's
built-in screenshot UI avoids an overlapping screenshot frontend.

Chapter 11 adds swaylock as a separate Stow package and starts swayidle from
Niri with explicit lifecycle commands. swayidle owns no credentials and does
not suspend on a timer; it coordinates lock, monitor power, and the
`before-sleep` event. greetd and tuigreet remain machine-level configuration in
the post-install repository.

Chapter 13 replaces the Niri bootstrap behavior with the complete portable
daily-driver bindings and adds Kitty as an independent package. Output modes,
scaling, TrackPoint tuning, and wallpaper binaries remain outside the shared
baseline until each host has been measured.

## Deployment lifecycle

All deployment operations run from the repository root:

```bash
stow --simulate --verbose --no-folding --target="$HOME" niri
stow --verbose --no-folding --target="$HOME" niri
stow --simulate --verbose --no-folding --target="$HOME" autostart
stow --verbose --no-folding --target="$HOME" autostart
stow --simulate --verbose --no-folding --target="$HOME" mimeapps
stow --verbose --no-folding --target="$HOME" mimeapps
stow --simulate --verbose --no-folding --target="$HOME" waybar fuzzel mako wallpapers
stow --verbose --no-folding --target="$HOME" waybar fuzzel mako wallpapers
stow --simulate --verbose --no-folding --target="$HOME" swaylock
stow --verbose --no-folding --target="$HOME" swaylock
stow --simulate --verbose --no-folding --target="$HOME" kitty
stow --verbose --no-folding --target="$HOME" kitty
niri validate
```

After tracked files change, reconcile the links with:

```bash
stow --restow --verbose --no-folding --target="$HOME" niri
stow --restow --verbose --no-folding --target="$HOME" autostart
stow --restow --verbose --no-folding --target="$HOME" mimeapps
stow --restow --verbose --no-folding --target="$HOME" waybar fuzzel mako wallpapers
stow --restow --verbose --no-folding --target="$HOME" swaylock
stow --restow --verbose --no-folding --target="$HOME" kitty
niri validate
```

Remove the package links without deleting repository files:

```bash
stow --delete --verbose --target="$HOME" niri
stow --delete --verbose --target="$HOME" autostart
stow --delete --verbose --target="$HOME" mimeapps
stow --delete --verbose --target="$HOME" waybar fuzzel mako wallpapers
stow --delete --verbose --target="$HOME" swaylock
stow --delete --verbose --target="$HOME" kitty
```

Stow must stop on a conflict. Existing targets are reviewed and backed up
outside the active path; they are never overwritten blindly.

## Decisions

| Role | Status |
| --- | --- |
| Deployment method | GNU Stow selected. |
| Terminal | Kitty selected for the canonical system. Foot may be compared separately. |
| Niri configuration | Starts the reviewed chapter 10 session components. |
| Removable-media autostart | udiskie through a portable XDG desktop entry. |
| Default applications | Portable `mimeapps.list` deployed as an independent Stow package. |
| Status bar | Waybar with native Niri modules. |
| Launcher | Fuzzel. |
| Notifications | Mako. |
| Wallpaper | swaybg; solid colour until a reviewed image is added. |
| Screenshots | Niri's built-in actions. |
| Screen lock | swaylock with PAM authentication. |
| Idle lifecycle | swayidle: lock at 5 min, monitors off at 10 min, lock before sleep. |
| Niri daily-driver controls | Portable focus, movement, workspaces, sizing, floating, tabs, screenshots, and hardware keys. |
| Kitty | Noto Sans Mono with an opaque dark cyan/fuchsia palette. |
| Keyboard layout | Portable baseline sets `us`; per-host overrides remain deferred. |

## Decisions still required

- Graphical greeter evolution beyond the system-level tuigreet baseline.
- Theme integration.
- Host override strategy for the two ThinkPads.

Each decision should be made in the post-install project before its
configuration is added here.
