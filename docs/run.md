# Running

## From the repository

```
nix run
```

This builds and starts `packages.default` (`noodle-desktop`), which runs the
wrapped wayfire with the in-repo config and the python bar.

## As an installed package

Add the flake as an input and use its default package, or install it directly:

```
nix profile install github:SDG-Den/noodle-desktop
```

The package's `mainProgram` is `wayfire`, so the installed command is `wayfire`
for this profile only if no other wayfire shadows it.

## What you should see

A wayfire session with a single top bar across the top of the output showing the
date and a clock that updates every second. There is no wf-shell panel and no
background from wf-shell.

## Running the bar alone

The bar needs a running layer-shell compositor to receive its surface:

```
nix run .#noodle-shell
```

Started outside a compositor it will print a GTK/layer-shell error and exit.
