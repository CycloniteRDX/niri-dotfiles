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
├── bash/
│   ├── .bash_profile
│   └── .bashrc
├── nano/
│   └── .config/nano/
├── micro/
│   └── .config/micro/
├── vim/
│   └── .config/vim/vimrc
└── niri/
    └── .config/
        └── niri/
            ├── config.kdl
            └── scripts/
                └── power-profile-refresh.py
```

New component packages, host overrides, or tests will be created
only when they contain reviewed files.

| Path | Intended role |
| --- | --- |
| `docs/` | Deployment, recovery, component map, and customization notes. |
| `autostart/` | Portable XDG autostart entries for reviewed session utilities. |
| `mimeapps/` | Portable XDG default-application associations. |
| `niri/` | Niri configuration plus the first target's measured input/output helper, arranged relative to `$HOME` for GNU Stow. |
| `waybar/` | Niri-aware status bar configuration and CSS. |
| `fuzzel/` | Application-launcher configuration. |
| `mako/` | Notification presentation and urgency policy. |
| `wallpapers/` | Reviewed wallpaper assets or documentation. |
| `swaylock/` | Portable lock-screen appearance; authentication remains PAM-owned. |
| `kitty/` | Portable terminal behavior and palette without shell state or secrets. |
| `bash/` | Interactive Bash behavior and prompt; never graphical-session autostart or generated history. |
| `nano/` | Predictable Nano behavior plus a project-owned KDL syntax definition. |
| `micro/` | Micro settings, RogueOS palette, and project-owned KDL and Kitty syntax definitions. |
| `vim/` | Plugin-free Vim learning configuration; undo and swap contents remain generated state. |
| `theme/` | Portable GTK preferences; packages and GSettings remain system-integration concerns. |
| `qt6ct/` | Qt 6 Fusion style, fonts, icons, portal dialogs, and Midnight Circuit palette. |
| `scripts/` | Narrow reviewed helpers deployed below `~/.local/bin`; no service or privilege policy. |
| Future component package | One independently deployable application or coherent configuration group. |
| Future `hosts/` | Small, non-secret overrides for hardware-specific differences. |
| Future `tests/` | Safe syntax and link checks that do not require a running graphical session. |

Using separate Stow packages keeps deployment explicit. For example, adding a
future Kitty package will not require deploying a launcher, bar, or theme at
the same time.

`--no-folding` is used during deployment so Stow creates a link for the tracked
file instead of replacing the whole `~/.config/niri` directory with one folded
directory symlink. This leaves the target structure easy to inspect and makes
future non-Stow files or host-specific composition less surprising.

## Post-install checkpoints

`main` is the latest reviewed desktop, not the configuration for every earlier
chapter. A clean installation following `arch-linux-post-install` therefore
checks out an immutable tag before deploying the files introduced by each
chapter:

| Post-install chapter | Git tag | Reference commit or corrected base | New configuration stage |
| --- | --- | --- | --- |
| 05 | `post-install-05-v1` | `499059b` | Minimal Niri and polkit bootstrap |
| 07 | `post-install-07-v1` | `291d85b` | udiskie XDG autostart |
| 09 | `post-install-09-v1` | `7d60d9d` | MIME defaults, including calendar files |
| 10 | `post-install-10-v1` | `dac44e8` | Waybar, Fuzzel, Mako and solid swaybg background |
| 11 | `post-install-11-v2` | `post-install-11-v1` | swaylock and swayidle lifecycle, with valid swaylock options |
| 13 | `post-install-13-v2` | `post-install-13-v1` | Portable daily-driver Niri and Kitty configuration, with the locker correction |
| 15 | `post-install-15-v2` | `post-install-15-v1` | Midnight Circuit visual foundation, with the locker correction |
| 17 | `post-install-17-v1` | — | Qt 6 appearance integration through qt6ct and Fusion |
| 18 | `post-install-18-v2` | `post-install-18-v1` | Battery-only automatic session suspend after 30 idle minutes, with an executable helper |
| 21 | `post-install-21-v1` | `b922d85` | Hardware-validated compact full-width Midnight Circuit Waybar with explicit icon-font dependencies |
| 22 | `post-install-22-v1` | Final documentation commit | Hardware-validated Niri v1 input, layout, bindings, and TLP-aware internal-panel refresh |
| 23 | `post-install-23-v1` | Final documentation commit | Hardware-validated Kitty, Mako, Fuzzel, swaylock, and system-resume monitor restoration |
| 25 | `post-install-25-v1` | Final documentation commit | Hardware-validated Bash, Nano, Micro, and plugin-free Vim terminal workflow |

The published earlier tags remain immutable historical checkpoints. Chapters
11, 13, and 15 use `v2` because their original swaylock configuration contained a
standalone `indicator` line. swaylock reads configuration keys as long-option
names; current swaylock has several `indicator-*` options but no unambiguous
standalone `--indicator`. The unlock indicator is already enabled by default,
so the corrected checkpoints remove that line while retaining the radius,
thickness, colours, and failed-attempt display.

Chapter 18 uses `v2` because `post-install-18-v1` tracked
`scripts/.local/bin/idle-suspend` as a non-executable file. The script content
was correct, but swayidle could not invoke it directly. The corrected tag
records Git mode `100755`; a local `chmod +x` alone is not a published fix.

The tags are deliberately detached checkpoints. Switching from one to the next
updates the tracked targets behind existing Stow links without pretending that
an earlier chapter is the current development tip. Before every switch, the
working tree must be clean. Fetch and select a checkpoint with:

```bash
git status --short --branch
git fetch --prune --tags origin
git switch --detach post-install-11-v2
git describe --tags --exact-match
git log -1 --oneline
```

Replace the example tag with the one required by the current chapter. Do not
merge an older checkpoint into a newer commit: because the older commit is
already an ancestor, that operation correctly leaves the newer checkout in
place. `git switch --detach TAG` is the intentional operation for reproducing
an earlier stage.

An annotated tag has two different strings. In:

```bash
git tag -a post-install-18-v2 \
  -m "Post-install chapter 18 automatic session suspend (executable fix)"
```

`post-install-18-v2` is the Git reference used by `git switch`; the quoted text
is only its human-readable annotation. Spaces are not valid in the reference
name. Inspect both without confusing them:

```bash
git tag --list 'post-install-18-v2'
git tag -n1 'post-install-18-v2'
```

The checkpoints are cumulative. When following the guide as a learning and
validation exercise, switch tag by tag. For an ordinary clean rebuild after
the design is stable, select the newest hardware-validated tag once after its
matching post-install dependencies exist; do not replay every earlier tag.
At the final desktop milestone, a semantic release tag can become the simple
reinstall target while the chapter tags remain immutable diagnostic history.

After a switch, run the chapter's `stow --restow` command for packages whose
tracked files changed and validate Niri before leaving the working session.
Normal personal development should happen on a branch, never by committing on
a detached checkpoint.

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
the post-install repository. Each non-empty swaylock configuration key must be
a supported long-option name; the visible unlock indicator needs no standalone
`indicator` key because it is enabled by default.

Chapter 13 replaces the Niri bootstrap behavior with the then-portable
daily-driver bindings and adds Kitty as an independent package. Chapter 22
later specializes the first target's input and internal output after hardware
measurement; the chapter 13 tag remains the portable historical checkpoint.

Chapter 15 adds the Midnight Circuit visual foundation without replacing the
modular desktop components. The shared package owns GTK preference files and a
project-authored SVG wallpaper. Niri owns cursor environment propagation and
the wallpaper fallback; the post-install repository owns the corresponding
official Arch packages and GSettings integration.

Chapter 17 adds qt6ct as an independent package for Qt 6 only. Niri exports
`QT_QPA_PLATFORMTHEME=qt6ct` to the applications it starts, but does not force
`QT_QPA_PLATFORM`; Qt can therefore select native Wayland when supported and
retain XWayland fallback where required. The tracked qt6ct configuration uses
Fusion, Papirus Dark, Noto fonts, the XDG Desktop Portal dialog provider, and a
custom Midnight Circuit palette. Its absolute color-scheme path assumes the
canonical `neon` account on both supported ThinkPads.

Chapter 18 creates the first reviewed `scripts` package. Its
`idle-suspend` helper reads UPower's boolean `OnBattery` property and does
nothing when the power state is external or unknown. Niri's existing swayidle
process calls it at 30 idle minutes. The helper requests suspend through
systemd with inhibitor checking enabled; it does not use `sudo`, change a TLP
profile, write sysfs, or create another idle daemon. Git must track the helper
as mode `100755`. This is especially important when preparing the commit from
Windows, where extracting a ZIP does not reliably reproduce Unix mode bits:

```bash
git add --chmod=+x scripts/.local/bin/idle-suspend
git ls-files --stage scripts/.local/bin/idle-suspend
```

The first field of the second command must be `100755` before the corrected
checkpoint is committed and tagged.

Chapter 21 starts the advanced personalization series without replacing a
component. Waybar becomes a compact full-width bar with dynamic Niri workspace
dots, a fixed-center US-style clock, and separate CPU, memory, temperature,
network, Bluetooth, microphone, speaker, brightness, power-profile, and battery
modules. Window title, tray, and the session button are deliberately omitted;
Niri's established bindings continue to own session exit and manual locking.

The CSS names `Font Awesome 7 Free` and `Symbols Nerd Font Mono`, supplied by
the official Arch packages `otf-font-awesome` and
`ttf-nerd-fonts-symbols-mono`. The former supplies the workspace dots and most
status icons; the latter supplies the Material Design brightness glyphs. These
are runtime dependencies of the `waybar` Stow package, not files vendored in
this repository. Installation and Fontconfig verification belong to
post-install chapter 21. The configuration also reuses btop, NetworkManager,
BlueZ/Blueman, PipeWire/WirePlumber, pavucontrol, brightnessctl, GNOME Calendar,
and TLP's `tlp-pd` interface from earlier chapters.

`post-install-21-v1` points to `b922d85`, the last clean Waybar-only
commit. It remains separate from the later Niri and coordinated input changes
even though the final cumulative Waybar state is also validated.

Chapter 22 finishes Niri v1 on the first target ThinkPad. The selected input
policy uses a US layout, right Alt Compose, Caps Lock as Ctrl, tuned touchpad
scroll and acceleration, a slower TrackPoint, pointer warp, focus following the
pointer, and workspace auto-back-and-forth. The window policy adds the accepted
gaps, proportional presets, gradient focus ring, shadow, rounded clipping,
overview, recent-window switcher, and the complete daily binding map.

The first measured internal panel is `eDP-1` at
`1920x1080@60.049` with scale `1.25`. The executable
`niri/.config/niri/scripts/power-profile-refresh.py` observes the standard
`org.freedesktop.UPower.PowerProfiles` D-Bus interface supplied by
`tlp-pd`: performance and balanced use 60.049 Hz, while power-saver uses
48.040 Hz. It also observes logind's resume signal and reapplies the selected
mode. The helper neither polls nor changes TLP policy.

Git must record the helper as mode `100755`. Its explicit runtime dependency
is `python-gobject`; Niri's media keys also make `playerctl` explicit. The
second ThinkPad must be measured before this target-specific output block is
reused or moved into a dedicated host package.

Chapter 23 keeps every established owner and refines four
existing surfaces together because the commits were already made as one
post-chapter-22 series. Fuzzel gains compact fzf-style application matching;
Mako gains history, urgency states, progress rendering, and action selection
through Fuzzel; swaylock gains a smaller state-coloured indicator; and Kitty
gains cursor trails, safer paste/clipboard behaviour, contextual tabs,
high-precision scrollback, command-finish notifications, and subtle
transparency. Niri's swayidle command also powers monitors on after logind
reports a system resume. This is distinct from the existing `resume` command,
which runs when user activity returns after the ten-minute monitor-off timeout.

All configured keys match the current documented option sets. PAM unlock,
notification actions, display restoration, scaling, and rendering behaviour
passed real-session validation on the first ThinkPad on 2026-09-08. Create
`post-install-23-v1` records that reviewed cumulative checkpoint.

Chapter 25 adds four independently deployable packages. Bash keeps the existing
login shell while adding bounded history, Readline preferences, small aliases,
Git/exit context, and a prompt that preserves existing `PROMPT_COMMAND` hooks.
Nano adds predictable editing behavior, Arch's packaged syntax collection, and
a local KDL definition. Micro adds its RogueOS palette and local KDL and Kitty
syntax definitions. Vim remains plugin-free while adding learning-oriented
defaults, separate undo/swap state, and a Wayland clipboard provider.

The four feature commits remain independently reviewable even though the
chapter checkpoint is cumulative. Bash and JSON syntax checks, Stow link
ownership, Vim loading and state directories, real KDL rendering in all three
editors, and the Bash prompt were validated on the first ThinkPad on
2026-09-08. Create `post-install-25-v1` at the final documentation commit in
both this repository and `arch-linux-post-install`.

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
stow --simulate --verbose --no-folding --target="$HOME" theme
stow --verbose --no-folding --target="$HOME" theme
stow --simulate --verbose --no-folding --target="$HOME" qt6ct
stow --verbose --no-folding --target="$HOME" qt6ct
stow --simulate --verbose --no-folding --target="$HOME" scripts
stow --verbose --no-folding --target="$HOME" scripts
stow --simulate --verbose --no-folding --target="$HOME" bash nano micro vim
stow --verbose --no-folding --target="$HOME" bash nano micro vim
test -x "$HOME/.local/bin/idle-suspend"
test -x "$HOME/.config/niri/scripts/power-profile-refresh.py"
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
stow --restow --verbose --no-folding --target="$HOME" theme
stow --restow --verbose --no-folding --target="$HOME" qt6ct
stow --restow --verbose --no-folding --target="$HOME" scripts
stow --restow --verbose --no-folding --target="$HOME" bash nano micro vim
test -x "$HOME/.config/niri/scripts/power-profile-refresh.py"
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
stow --delete --verbose --target="$HOME" theme
stow --delete --verbose --target="$HOME" qt6ct
stow --delete --verbose --target="$HOME" scripts
stow --delete --verbose --target="$HOME" bash nano micro vim
```

Stow must stop on a conflict. Existing targets are reviewed and backed up
outside the active path; they are never overwritten blindly.

## Decisions

| Role | Status |
| --- | --- |
| Deployment method | GNU Stow selected. |
| Terminal | Kitty selected for the canonical system. Foot may be compared separately. |
| Niri configuration | Finished chapter 22 daily-driver behavior on the first target ThinkPad. |
| Removable-media autostart | udiskie through a portable XDG desktop entry. |
| Default applications | Portable `mimeapps.list` deployed as an independent Stow package. |
| Status bar | Compact full-width Waybar with native Niri workspaces, icon-led status modules, and the chapter 21 Midnight Circuit presentation. |
| Launcher | Fuzzel. |
| Notifications | Mako. |
| Wallpaper | swaybg with the project-owned `midnight-circuit.svg` and a dark solid fallback. |
| Screenshots | Niri's built-in actions. |
| Screen lock | swaylock with PAM authentication. |
| Idle lifecycle | swayidle: lock at 5 min, monitors off at 10 min, battery-only suspend at 30 min, lock before sleep. |
| Niri daily-driver controls | Validated focus, movement, workspaces, sizing, floating, tabs, overview, recent windows, screenshots, and hardware keys. |
| Internal output | First target: `eDP-1`, 1920×1080 at 60.049/48.040 Hz, scale 1.25. |
| Refresh integration | Event-driven TLP profile observer; 48.040 Hz only in power-saver and 60.049 Hz otherwise. |
| Visual palette | Midnight Circuit: dark navy and graphite, cyan primary accent, restrained fuchsia secondary accent. |
| GTK | `adw-gtk3-dark` for GTK 3 and the standard dark preference for GTK 4/libadwaita. |
| Qt 6 | qt6ct with Fusion, the Midnight Circuit palette, Papirus Dark, Noto fonts, and portal-backed standard dialogs. |
| Icons | Papirus Dark. |
| Waybar glyph fonts | `Font Awesome 7 Free` from `otf-font-awesome` and `Symbols Nerd Font Mono` from `ttf-nerd-fonts-symbols-mono`. |
| Cursor | `breeze_cursors`, 24 px, exported by Niri for the Wayland session. |
| Kitty | Noto Sans Mono with the shared Midnight Circuit palette, 94% background opacity, cursor trails, contextual tabs, and command-finish notifications. |
| Bash | Existing login shell with bounded history, Readline search, small aliases, Git and exit context, and the RogueOS prompt. |
| Nano | Predictable fallback editor with packaged syntax definitions and project KDL highlighting. |
| Micro | Canonical approachable editor with the RogueOS palette, external Wayland clipboard, and KDL/Kitty syntax. |
| Vim | Plugin-free learning and recovery editor with isolated state and a Wayland clipboard provider. |
| Keyboard and pointing | `us`, right Alt Compose, Caps Lock as Ctrl, and validated touchpad/TrackPoint tuning. |

## Current personalization order

1. Waybar — complete and hardware-validated.
2. Niri — moved forward, complete, and hardware-validated on the first target.
3. Kitty, Mako, Fuzzel, swaylock, and resume monitor restoration — complete and
   hardware-validated together in chapter 23.
4. swaybg and static wallpaper presentation — complete without automation.
5. tuigreet — complete and hardware-validated in post-install chapter 24; no
   dotfiles package required.
6. Bash, Nano, Micro, and Vim — complete and hardware-validated in chapter 25.
7. Plymouth — minimal RogueOS theme complete and hardware-validated in
   post-install chapter 26; no dotfiles package required.
8. GTK and Qt cross-application consistency review — next.
9. Cross-component validation and a stable dotfiles release.

The first pass keeps every current component. SwayNotificationCenter, another
wallpaper renderer, Eww, or any other replacement is evaluated only after the
complete current stack is visually coherent and hardware-validated.

## Decisions still required

- Measure the second ThinkPad and decide whether its output policy requires a
  dedicated host package.

Each decision should be made in the post-install project before its
configuration is added here.
