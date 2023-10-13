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

  # postInstall = ''
  #   ln -s $out/sbin/sysctl ${sysctl}/bin/sysctl 
  # '';

  buildPhase = ''
    install -Dm644 preload.service "$out/usr/lib/systemd/system/preload.service"
  '';

  #./configure --prefix=$out \
  #          --localstatedir=/var \
  #          --mandir=$out/share/man \
  #          --sbindir=$out/bin \
  #          --sysconfdir=$out/etc

  meta = with lib; {
    description =
      "Makes applications run faster by prefetching binaries and shared objects";
    homepage = "http://sourceforge.net/projects/preload";
    license = licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
