{ stdenv, lib, fetchurl, writeScript, makeDesktopItem, copyDesktopItems, jre
, imagemagick, coreutils }:

let

  icon = fetchurl {
    url = "https://jdownloader.org/_media/vote/trazo.png";
    sha256 = "3ebab992e7dd04ffcb6c30fee1a7e2b43f3537cb2b22124b30325d25bffdac29";
  };

  src = fetchurl {
    url = "https://installer.jdownloader.org/JDownloader.jar";
    sha256 = "9951b786e24fc3777a0df0a7b516ba53d0c8e778d6a69ebc29dcff86ee6b5829";
  };

  wrapper = writeScript "jdownloader" ''
    #! ${stdenv.shell}
    PATH=${lib.makeBinPath [ jre coreutils ]}
    JDJAR=''${XDG_DATA_HOME:-$HOME/.local/share}/jdownloader/JDownloader.jar
    if [ ! -f ''${JDJAR} ]; then
        install -Dm755 ${src} ''${JDJAR}
    fi
    ${jre}/bin/java -jar ''${JDJAR} "''${@}"
  '';

in stdenv.mkDerivation rec {
  inherit src;

  pname = "jdownloader2";
  version = "2.0";

  dontUnpack = true;

  nativeBuildInputs = [ jre imagemagick copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "JDownloader 2";
      exec = wrapper;
      icon = "jdownloader";
      comment = "Free, open-source download management tool.";
      desktopName = "JDownloader 2";
      genericName = "JDownloader 2";
      categories = [ "Network" ];
    })
  ];

  installPhase = ''
    mkdir -pv $out/bin $out/share/applications
    cp ${src} $out/bin/JDownloader.jar
    
    # create icons
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" \
        ${icon} \
        $out/share/icons/hicolor/"$size"x"$size"/apps/jdownloader.png
    done

    copyDesktopItems
  '';

  # Some easy metadata, in case I forget.
  meta = with lib; {
    homepage = "https://jdownloader.org/";
    description = "Free, open-source download management tool";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [  ];
  };
}
