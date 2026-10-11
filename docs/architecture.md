# Architecture

## Components

- **wayfire (fork)**. The compositor, built from `github:SDG-Den/wayfire`
  (version 0.12.0). It is built against the system `wlroots_0_20` package and
  builds the fork's bundled `wf-config` subproject because the fork requires
  `wf-config >= 0.12` while nixpkgs ships `0.10`.
- **noodle-shell**. A python 3 GTK3 application that creates one layer-shell
  surface and draws a clock. Built with `hatchling`.
- **noodle-desktop**. The default package. A `symlinkJoin` of wayfire and
  noodle-shell, with a `makeWrapper` hook on `bin/wayfire` that supplies the
  config file and plugin paths.

## Runtime flow

1. `nix run` starts `.../bin/wayfire` from the `noodle-desktop` package.
2. The wrapper has exported `WAYFIRE_CONFIG_FILE` pointing at a store copy of
   `config/wayfire.ini`, and added `$out/bin` to `PATH`.
3. Wayfire loads the config. Its `[autostart]` section is handled by the
   `autostart` plugin, which starts `noodle-shell` because it is now on `PATH`.
4. `noodle-shell` connects to the wayfire Wayland socket, calls
   `GtkLayerShell.init_for_window`, anchors a `TOP` surface across the width of
   the output, and shows a clock.
5. `autostart_wf_shell = false` keeps the wf-shell panel from also appearing, so
   the python bar is the only top bar.

## Why these choices

- **System wlroots, bundled wf-config.** nixpkgs at the pinned rev provides
  `wlroots_0_20` (0.20.2), which the fork accepts, but only `wf-config` 0.10,
  which it rejects. Building the fork's `wf-config` subproject satisfies the
  version constraint without carrying a second copy of wlroots.
- **Layer shell, not wf-shell integration.** wayfire exposes the standard
  `wlr-layer-shell` protocol through wlroots. Any layer-shell client works, so
  the bar needs no wayfire-specific plugin or IPC.
- **Store config via `WAYFIRE_CONFIG_FILE`.** `wayfire --config` and the
  environment variable both override the default `~/.config/wayfire.ini`, so the
  package can carry its own config without touching the user's home directory.

## Environment variables set by the wrapper

- `WAYFIRE_CONFIG_FILE`: path to the packaged `wayfire.ini`.
- `WAYFIRE_PLUGIN_PATH`: `$out/lib/wayfire`.
- `WAYFIRE_PLUGIN_XML_PATH`: `$out/share/wayfire/metadata`.
- `PATH`: prefixed with `$out/bin` so `noodle-shell` resolves.
