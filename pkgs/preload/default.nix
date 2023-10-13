{ lib, stdenv, fetchurl, autoconf, automake, pkg-config, bash, glib }:

stdenv.mkDerivation rec {
  pname = "preload";
  version = "0.6.4";

  src = fetchurl {
    url =
      "http://downloads.sourceforge.net/sourceforge/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-0KVY6DyymlHZ2Wc27zn0tOVeQ6WJrRrsWUoEjKIvgWs=";
  };

  patches = [ ./Makefile.patch ];

  nativeBuildInputs = [ autoconf automake pkg-config ];
  buildInputs = [ bash glib ];

  configureFlags = [
    "--localstatedir=/var"
  ];

  postInstall = ''
    make sysconfigdir=/$out/etc/conf.d install
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