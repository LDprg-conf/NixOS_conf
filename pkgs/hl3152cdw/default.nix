{ lib, stdenv, fetchurl, cups, dpkg, gnused, makeWrapper, ghostscript, file, a2ps, coreutils, gawk }:

let
  version = "1.1.4-0";
  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101633/hl3152cdwcupswrapper-${version}.i386.deb";
    sha256 = "sha256-hbtmF4c57j81m7Z9cbTqHmUjGaq4wtjlXbOblz6GzMk=";
  };
  srcdir = "hl3152cdw_cupswrapper_GPL_source_${version}";
  cupssrc = fetchurl {
    url = "https://download.brother.com/welcome/dlf101645/${srcdir}.tar.gz";
    sha256 = "sha256-/cImJGaCBCw697L+j6JbWOnfZz0zyTiSx2+a2joWSF0=";
  };
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101632/hl3152cdwlpr-1.1.3-0.i386.deb";
    sha256 = "sha256-gIn8nGl0j7intGBPIEXEXE9kjjsIdUDz8ZePtFu3I1A=";
  };
in
stdenv.mkDerivation {
  pname = "cups-brother-hl3152cdw";
  inherit version;
  nativeBuildInputs = [ makeWrapper dpkg ];
  buildInputs = [ cups ghostscript a2ps ];

  unpackPhase = ''
    tar -xvf ${cupssrc}
  '';

  buildPhase = ''
    gcc -Wall ${srcdir}/brcupsconfig/brcupsconfig.c -o brcupsconfpt1
  '';

  installPhase = ''
    # install lpr
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/hl3152cdw/lpd/filterhl3152cdw \
      --replace /opt "$out/opt"
    substituteInPlace $out/opt/brother/Printers/hl3152cdw/inf/setupPrintcapij \
      --replace /opt "$out/opt"

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/hl3152cdw/lpd/psconvertij2

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/opt/brother/Printers/hl3152cdw/lpd/brhl3152cdwfilter
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_hl3152cdw

    wrapProgram $out/opt/brother/Printers/hl3152cdw/lpd/psconvertij2 \
      --prefix PATH ":" ${ lib.makeBinPath [ gnused coreutils gawk ] }

    wrapProgram $out/opt/brother/Printers/hl3152cdw/lpd/filterhl3152cdw \
      --prefix PATH ":" ${ lib.makeBinPath [ ghostscript a2ps file gnused coreutils ] }


    dpkg-deb -x ${cupsdeb} $out

    substituteInPlace $out/opt/brother/Printers/hl3152cdw/cupswrapper/cupswrapperhl3152cdw \
      --replace /opt "$out/opt"

    mkdir -p $out/lib/cups/filter
    ln -s $out/opt/brother/Printers/hl3152cdw/cupswrapper/cupswrapperhl3152cdw $out/lib/cups/filter/cupswrapperhl3152cdw

    ln -s $out/opt/brother/Printers/hl3152cdw/cupswrapper/brother_hl3152cdw_printer_en.ppd $out/lib/cups/filter/brother_hl3152cdw_printer_en.ppd

    cp brcupsconfpt1 $out/opt/brother/Printers/hl3152cdw/cupswrapper/
    ln -s $out/opt/brother/Printers/hl3152cdw/cupswrapper/brcupsconfpt1 $out/lib/cups/filter/brcupsconfpt1
    ln -s $out/opt/brother/Printers/hl3152cdw/lpd/filterhl3152cdw $out/lib/cups/filter/brother_lpdwrapper_hl3152cdw

    wrapProgram $out/opt/brother/Printers/hl3152cdw/cupswrapper/cupswrapperhl3152cdw \
      --prefix PATH ":" ${ lib.makeBinPath [ gnused coreutils gawk ] }
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother hl3152cdw printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
  };
}
