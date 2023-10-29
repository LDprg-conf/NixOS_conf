# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  preload = pkgs.callPackage ./preload { };
  jdownload2 = pkgs.callPackage ./jdownload2 { };
  wine-nine = callPackage ./wine-nine-standalone {
    nine32 = pkgsi686Linux.wine-nine-standalone-unwrapped;
    nine64 = wine-nine-standalone-unwrapped;
  };
  wine-nine-standalone-unwrapped = callPackage ./wine-nine-standalone/nine.nix { };
}
