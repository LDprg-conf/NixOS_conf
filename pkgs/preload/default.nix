{ lib, stdenv, fetchurl, sysctl, autoconf, automake, pkg-config, bash, glib }:

stdenv.mkDerivation rec {
  pname = "preload";
  version = "0.6.4";

  src = fetchurl {
    url =
      "http://downloads.sourceforge.net/sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-0KVY6DyymlHZ2Wc27zn0tOVeQ6WJrRrsWUoEjKIvgWs=";
  };

  patches = [ ./preload.service.patch ];

  nativeBuildInputs = [ autoconf automake pkg-config sysctl ];
  buildInputs = [ bash glib ];

  configureFlags = [ "--localstatedir=/tmp" ];

  postInstall = ''
    mkdir -p $out/lib/systemd/system/
    cp -rv ./a/preload.service $out/lib/systemd/system/

    substituteInPlace "$out/lib/systemd/system/preload.service" \
            --replace "/usr/" "$out/" \
            --replace "/etc/" "$out/etc/"
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
