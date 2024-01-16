# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgsi686Linux, pkgs ? (import ../nixpkgs.nix) { } }: {
  jdownload2 = pkgs.callPackage ./jdownload2 { };
  fdm = pkgs.callPackage ./fdm { };
}
