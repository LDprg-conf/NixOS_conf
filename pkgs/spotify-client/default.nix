{ lib, stdenv, callPackage, ... }@args:

let
  extraArgs = removeAttrs args [ "callPackage" ];

  pname = "spotify-client";

  meta = with lib; {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "spotify";
  };

in callPackage ./linux.nix (extraArgs // { inherit pname meta; })
