{ fetchurl, lib, stdenv, squashfsTools, xorg, alsa-lib, makeShellWrapper
, wrapGAppsHook, openssl, freetype, glib, pango, cairo, atk, gdk-pixbuf, gtk3
, cups, nspr, nss_latest, libpng, libnotify, libgcrypt, systemd, fontconfig
, dbus, expat, ffmpeg_4, curlWithGnuTls, zlib, gnome, at-spi2-atk, at-spi2-core
, libpulseaudio, libdrm, mesa, libxkbcommon, pname, meta, harfbuzz
# High-DPI support: Spotify's --force-device-scale-factor argument
# not added if `null`, otherwise, should be a number.
, deviceScaleFactor ? null }:

let mirror = "http://repository.spotify.com/pool/non-free/s/spotify-client/";
in stdenv.mkDerivation rec {
  pname = "spotify-client";
  version = "1.2.13.661.ga588f749";
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

  nativeBuildInputs = [ wrapGAppsHook makeShellWrapper squashfsTools ];

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr $out
    cp -r usr/share $out/share
    ln -s $out/usr/bin/spotify $out/bin/spotify
  '';

  meta = with lib; {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "spotify";
  };
}
