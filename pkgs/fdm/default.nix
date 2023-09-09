{ lib, stdenv, fetchurl, dpkg, wrapGAppsHook, autoPatchelfHook, makeWrapper, udev, libdrm
, libpqxx, openssl, ffmpeg, xdg-utils, libtorrent-rasterbar, alsa-lib, libpulseaudio, qt5, unixODBC, gst_all_1 }:

stdenv.mkDerivation rec {
  pname = "fdm";
  version = "6.19.0";

  src = fetchurl {
    url =
      "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb";
    hash = "sha256-3KmNhkEEOzW5qiK6e4ZPI9wbTdA2EFWUH5Z1K8kdXWw=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs =
    [ dpkg wrapGAppsHook autoPatchelfHook qt5.wrapQtAppsHook ];

  buildInputs = [ makeWrapper libdrm libpqxx alsa-lib libpulseaudio unixODBC stdenv.cc.cc openssl ffmpeg xdg-utils libtorrent-rasterbar ]
    ++ (with gst_all_1; [
      gstreamer
      gst-libav
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ]);

  runtimeDependencies = [ (lib.getLib udev) openssl ffmpeg xdg-utils libtorrent-rasterbar ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt/freedownloadmanager $out
    cp -r usr/share $out
    ln -s $out/freedownloadmanager/fdm $out/bin/${pname}

    substituteInPlace $out/share/applications/freedownloadmanager.desktop \
      --replace 'Exec=/opt/freedownloadmanager/fdm' 'Exec=${pname}' \
      --replace "Icon=/opt/freedownloadmanager/icon.png" "Icon=$out/freedownloadmanager/icon.png"
  '';

  postInstall = ''
    wrapProgram "$out/bin/fdm" --set QT_QPA_PLATFORM xcb"
  '';

  meta = with lib; {
    description = "A smart and fast internet download manager";
    homepage = "https://www.freedownloadmanager.org";
    # License cant be set to unfree in flakes so just imagine fdm beeing unfree
    # license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
  };
}
