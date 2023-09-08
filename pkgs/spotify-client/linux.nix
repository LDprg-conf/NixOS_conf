{ fetchurl, lib, stdenv, squashfsTools, xorg, alsa-lib, makeShellWrapper
, wrapGAppsHook, openssl, freetype, glib, pango, cairo, atk, gdk-pixbuf, gtk3
, cups, nspr, nss_latest, libpng, libnotify, libgcrypt, systemd, fontconfig
, dbus, expat, ffmpeg_4, curlWithGnuTls, zlib, gnome, at-spi2-atk, at-spi2-core
, libpulseaudio, libdrm, mesa, libxkbcommon, pname, meta, harfbuzz, dpkg, autoPatchelfHook, callPackage, qt5 
# High-DPI support: Spotify's --force-device-scale-factor argument
# not added if `null`, otherwise, should be a number.
, deviceScaleFactor ? null }:

let
  version = "1.2.11.916.geb595a67";

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curlWithGnuTls
    dbus
    expat
    ffmpeg_4 # Requires libavcodec < 59 as of 1.2.9.743.g85d9593d
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdrm
    libgcrypt
    libnotify
    libpng
    libpulseaudio
    libxkbcommon
    mesa
    nss_latest
    pango
    stdenv.cc.cc
    systemd
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
    zlib
  ];

  mirror = "http://repository.spotify.com/pool/non-free/s/spotify-client/";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "${mirror}/${pname}_${version}_amd64.deb";
    hash = "sha256-746imLXqxzf9zK2QEVRuWkLA6m+HHXBYZFUwTD0HEVc=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs =
    [ dpkg autoPatchelfHook wrapGAppsHook qt5.wrapQtAppsHook ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curlWithGnuTls
    dbus
    expat
    ffmpeg_4 # Requires libavcodec < 59 as of 1.2.9.743.g85d9593d
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdrm
    libgcrypt
    libnotify
    libpng
    libpulseaudio
    libxkbcommon
    mesa
    nss_latest
    pango
    stdenv.cc.cc
    systemd
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
    zlib
  ];

  meta = meta // {
    maintainers = with lib.maintainers; [
      eelco
      ftrvxmtrx
      sheenobu
      timokau
      ma27
    ];
  };
}
