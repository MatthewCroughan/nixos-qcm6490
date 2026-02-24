{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  dconf,
  ninja,
  pkg-config,
  python3,
  wayland-scanner,
  wrapGAppsHook3,
  appstream,
  feedbackd,
  fzf,
  glib,
  gmobile,
  gnome-desktop,
  gtk4,
  hunspell,
  json-glib,
  libhandy,
  libxkbcommon,
  systemd,
  nix-update-script,
  scdoc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "stevia";

  version = "0.52.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/Phosh";
    repo = "stevia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LE2+1RkxD8Sj2H/3NFzcYXZktlVGoNzWrE0UO5sJCAM=";
  };

  mesonFlags = [
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
    "-Dsystemd_user_unit_dir=${placeholder "out"}/lib/systemd/user"
  ];

  postPatch = ''
    patchShebangs --build tools/write-layout-info.py
  '';

  nativeBuildInputs = [
    scdoc
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    appstream
    feedbackd
    fzf
    glib
    dconf
    gmobile
    gnome-desktop
    gtk4
    hunspell
    json-glib
    libhandy
    libxkbcommon
    systemd
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "User friendly on screen keyboard for Phosh";
    homepage = "https://gitlab.gnome.org/World/Phosh/stevia";
    changelog = "https://gitlab.gnome.org/World/Phosh/stevia/-/releases/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      ungeskriptet
      armelclo
    ];
    mainProgram = "phosh-osk-stevia";
  };
})
