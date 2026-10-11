{
  lib,
  symlinkJoin,
  makeWrapper,
  wayfire,
  noodle-shell,
  configFile,
}:

symlinkJoin {
  pname = "noodle-desktop";
  inherit (wayfire) version;

  paths = [
    wayfire
    noodle-shell
  ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/wayfire \
      --set WAYFIRE_CONFIG_FILE ${configFile} \
      --prefix PATH : $out/bin \
      --prefix WAYFIRE_PLUGIN_PATH : $out/lib/wayfire \
      --prefix WAYFIRE_PLUGIN_XML_PATH : $out/share/wayfire/metadata
  '';

  passthru = {
    inherit wayfire noodle-shell;
  };

  meta = wayfire.meta // {
    description = "Wayfire fork with the noodle-desktop config and python GTK layer-shell top bar";
    mainProgram = "wayfire";
    outputsToInstall = [ "out" ];
    priority = (wayfire.meta.priority or lib.meta.defaultPriority) - 1;
  };
}
