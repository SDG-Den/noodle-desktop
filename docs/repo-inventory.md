# Repository inventory

Recorded 2026-10-11. This documents the state of `noodle-desktop` before the
scaffold was added, and the layout the scaffold introduces.

## State before the scaffold

- `README.md`: a single line, `# noodle-desktop`.
- `.gitignore`: ignored `result`, `result-*`, `.direnv`, and
  `**/.nixos-test-history`.
- Git history: one commit, `e17fae3` "Initial commit", branch `main`, tracking
  `origin/main`.
- No flake, no nix files, no wayfire config, no python, no `docs/`.

There was no pre-existing behaviour to preserve; the repository was a shell.

## Layout after the scaffold

- `flake.nix`: pins nixpkgs and the wayfire fork, exposes `packages.default`
  (the wrapped desktop), `packages.wayfire`, `packages.noodle-shell`, a
  `devShells.default`, and the formatter.
- `nix/packages/wayfire-fork.nix`: builds the `SDG-Den/wayfire` fork against
  system `wlroots_0_20` with the bundled `wf-config` subproject.
- `nix/packages/noodle-shell.nix`: builds the python GTK layer-shell bar.
- `nix/packages/noodle-desktop.nix`: wraps wayfire so it loads the in-repo
  config and can launch `noodle-shell`.
- `config/wayfire.ini`: the wayfire configuration shipped by the default
  package.
- `shell/`: the python project (`pyproject.toml`, `src/noodle_shell/`).
- `docs/`: this documentation.

See `docs/architecture.md` for how the pieces fit together.
