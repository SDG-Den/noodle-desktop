# Building

## Prerequisites

- Nix with flakes enabled.
- Network access for the first evaluation (nixpkgs, the wayfire fork, and its
  submodules).

## Build commands

```
nix build .#wayfire        # the compositor alone
nix build .#noodle-shell   # the bar alone
nix build                  # the wrapped desktop (default)
```

`nix build` is the fastest way to catch breakage in the nix expressions without
starting a compositor.

## How the wayfire derivation is assembled

`nix/packages/wayfire-fork.nix` is modelled on the nixpkgs `wayfire` derivation
but retargeted at the fork:

- `src` is the `wayfire-fork` flake input, fetched with submodules
  (`git+https://github.com/SDG-Den/wayfire?submodules=1&rev=...`). The submodules
  supply `wf-config`, `wf-json`, `wf-utils`, and `wf-touch`, all of which the
  fork's `meson.build` references unconditionally.
- `wlroots` is the system `wlroots_0_20` (`-Duse_system_wlroots=enabled`).
- `wf-config` is the bundled subproject (`-Duse_system_wfconfig=disabled`).
- `yyjson` is provided as a system build input so `wf-json` finds it via
  pkg-config instead of downloading the `yyjson` wrap.
- `--wrap-mode=nodownload` makes any missing wrap a hard error rather than a
  sandboxed network attempt.

## Overriding the fork source

During development, point the input at the local checkout:

```
nix build --override-input wayfire-fork path:/home/den/repos/wayfire-fork
```

The local checkout must have its submodules initialised:

```
git -C /home/den/repos/wayfire-fork submodule update --init --recursive
```

## Pinned nixpkgs

`flake.nix` pins nixpkgs to `e7439b6b14ad3cc35d05608ebca9bce01a25f5f8` (the same
revision the dendrite flake locks). The pin matters: it is a nixpkgs that
provides `wlroots_0_20`. Tracking `nixos-unstable` would work as long as the
same attribute exists, but the pin also avoids fetching a second nixpkgs.
