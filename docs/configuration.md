# Configuration

## The wayfire config

`config/wayfire.ini` is copied into the nix store and pointed at by the wrapper's
`WAYFIRE_CONFIG_FILE`. Editing the file and rebuilding is the way to change the
session configuration.

Relevant sections:

- `[core] plugins`: the list of wayfire plugins to load. `autostart` is required
  for the bar to start.
- `[autostart]`: `noodle_shell = noodle-shell` starts the bar. The name
  `noodle-shell` is resolved through the `PATH` the wrapper sets.
  `autostart_wf_shell = false` disables the wf-shell panel and background.
- `[command]`: application launch bindings, for example the terminal.

## Environment variables

- `WAYFIRE_CONFIG_FILE`: overrides the config path. Set by the wrapper; can be
  overridden further by exporting a different value, or by passing
  `wayfire --config <path>`.
- `WAYFIRE_PLUGIN_PATH`: where wayfire loads plugins from. Set by the wrapper.
- `WAYFIRE_PLUGIN_XML_PATH`: where wayfire reads plugin metadata. Set by the
  wrapper.

## Overriding the config without rebuilding

Wayfire reads `WAYFIRE_CONFIG_FILE` at startup. To use a config from outside the
store for a one-off run:

```
WAYFIRE_CONFIG_FILE=/path/to/wayfire.ini nix run
```

Note that the wrapper uses `--set`, so a value exported by the caller is
replaced, not extended. Use `wayfire --config /path/to/wayfire.ini` to be
unambiguous.

## The bar

The bar currently takes no configuration. Its behaviour is fixed in
`shell/src/noodle_shell/bar.py`: namespace `noodle-shell`, layer `TOP`, anchored
to the top, left, and right edges, with an exclusive zone so maximized windows
stop below it.
