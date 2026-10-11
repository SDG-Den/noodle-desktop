{
  lib,
  python3Packages,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
  gtk-layer-shell,
}:

python3Packages.buildPythonApplication {
  pname = "noodle-shell";
  version = "0.1.0";

  pyproject = true;
  build-system = [ python3Packages.hatchling ];

  src = lib.cleanSource ../../shell;

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  dependencies = [ python3Packages.pygobject3 ];

  pythonImportsCheck = [ "noodle_shell" ];

  meta = {
    description = "Top bar layer-shell client for the noodle-desktop wayfire session";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "noodle-shell";
  };
}
