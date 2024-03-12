# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'

{ pkgs ? (import ../nixpkgs.nix) { } }: {
  jdownload2 = pkgs.callPackage ./jdownload2 { };
  fdm = pkgs.callPackage ./fdm { };
  fish-abbreviation-tips =
    pkgs.callPackage ./fish-plugins/fish-abbreviation-tips.nix { };
  gitnow = pkgs.callPackage ./fish-plugins/gitnow.nix { };
  vk_hdr_layer = pkgs.callPackage ./vk-hdr-layer { };
}
