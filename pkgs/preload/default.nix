{ lib, stdenv, fetchurl, bash, glib2 }:

stdenv.mkDerivation rec {
  pname = "preload";
  version = "0.6.4-9";

  src = fetchurl {
    url =
      "http://downloads.sourceforge.net/sourceforge/preload/${finalAttrs.version}.tar.gz";
    hash = "sha256-vSbj3YlyCs4bADpDqxAkcSC1VsoQZ2j+jIKe577WtDU=";
  };

  buildInputs = [ bash glib2s ];

  installPhase = ''
    tar xvzf $src
    mkdir -p "$out/bin"
    cp preload $out/bin
  '';

  meta = with lib; {
    description =
      "Makes applications run faster by prefetching binaries and shared objects";
    homepage = "http://sourceforge.net/projects/preload";
    license = licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
