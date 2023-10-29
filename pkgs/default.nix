# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  preload = pkgs.callPackage ./preload { };
  jdownload2 = pkgs.callPackage ./jdownload2 { };
  wine-nine = pkgs.callPackage ./wine-nine-standalone {
    nine32 = pkgs.i686-linux.wine-nine-standalone-unwrapped;
    nine64 = pkgs.x86_64-linux.wine-nine-standalone-unwrapped;
  };
  wine-nine-standalone-unwrapped = pkgs.callPackage ./wine-nine-standalone/nine.nix { };
}
