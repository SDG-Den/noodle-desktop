{
  description = "noodle-desktop: a wayfire fork with an in-repo config and a python GTK layer-shell top bar";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/e7439b6b14ad3cc35d05608ebca9bce01a25f5f8";

    wayfire-fork = {
      url = "git+https://github.com/SDG-Den/wayfire?submodules=1&rev=fdf8832e4263db54e2fef2abf30326e16877b8a2";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      wayfire-fork,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    {
      packages = forAllSystems (
        { pkgs, ... }:
        rec {
          wayfire = pkgs.callPackage ./nix/packages/wayfire-fork.nix { src = wayfire-fork; };
          noodle-shell = pkgs.callPackage ./nix/packages/noodle-shell.nix { };
          noodle-desktop = pkgs.callPackage ./nix/packages/noodle-desktop.nix {
            wayfire = wayfire;
            inherit noodle-shell;
            configFile = ./config/wayfire.ini;
          };
          default = noodle-desktop;
        }
      );

      devShells = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python3
              python3Packages.pygobject3
              gobject-introspection
              gtk3
              gtk-layer-shell
              nixfmt
            ];
          };
        }
      );

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt);
    };
}
