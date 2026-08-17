# Dotfiles design notes

## Proposed repository layout

The final layout will be chosen together with the deployment method. A likely
shape is:

```text
.
├── README.md
├── docs/
├── home/
│   └── .config/
├── hosts/
├── scripts/
└── tests/
```

This is a proposal, not a directory tree to populate yet.

| Path | Intended role |
| --- | --- |
| `home/` | Portable files arranged relative to the home directory. |
| `hosts/` | Small, non-secret overrides for hardware-specific differences. |
| `scripts/` | Narrow deployment or validation helpers, only when they reduce mistakes. |
| `tests/` | Safe syntax and link checks that do not require a running graphical session. |
| `docs/` | Deployment, recovery, component map, and customization notes. |

## Decisions still required

- Deployment method: GNU Stow, a dedicated dotfile manager, or a small custom
  symlink workflow.
- Terminal: keep Kitty as the default or adopt Foot after comparison.
- Greeter and session launch model.
- Bar or shell architecture.
- Launcher.
- Notification daemon.
- Lock and idle components.
- Wallpaper and theme integration.
- Host override strategy for the two ThinkPads.

Each decision should be made in the post-install project before its
configuration is added here.
