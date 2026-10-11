{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  libGL,
  libdrm,
  libexecinfo,
  libevdev,
  libinput,
  libjpeg,
  libxkbcommon,
  libxml2,
  vulkan-headers,
  wayland,
  wayland-protocols,
  wlroots_0_20,
  cairo,
  pango,
  glm,
  yyjson,
  libxcb-wm,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.12.0";

  inherit src;

  outputs = [
    "out"
    "man"
  ];

  # libdrm installs drm.h under include/libdrm/, which xf86drmMode.h includes as
  # <drm.h>; plugins pull that header in without declaring libdrm as a meson dep.
  NIX_CFLAGS_COMPILE = "-I${lib.getDev libdrm}/include/libdrm";

  postPatch = ''
    substituteInPlace plugins/common/wayfire/plugins/common/cairo-util.hpp \
      --replace-fail "<drm_fourcc.h>" "<libdrm/drm_fourcc.h>" || true
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libdrm
    libexecinfo
    libevdev
    libinput
    libjpeg
    libxkbcommon
    libxml2
    vulkan-headers
    wayland-protocols
    libxcb-wm
    yyjson
    glm
  ];

  propagatedBuildInputs = [
    wlroots_0_20
    wayland
    cairo
    pango
  ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Duse_system_wlroots=enabled"
    "-Duse_system_wfconfig=disabled"
    "-Dvulkan_effects=false"
    "-Dtests=disabled"
    "-Dwf-config:tests=disabled"
    "-Dwf-touch:tests=disabled"
  ];

  meta = {
    homepage = "https://github.com/SDG-Den/wayfire";
    description = "3D Wayland compositor (SDG-Den fork), built against system wlroots 0.20";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "wayfire";
  };
})
