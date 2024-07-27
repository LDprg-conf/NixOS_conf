{ pkgs }: {
  jdownload2 = pkgs.callPackage ./jdownload2 { };
  fdm = pkgs.callPackage ./fdm { };
  fish-abbreviation-tips =
    pkgs.callPackage ./fish-plugins/fish-abbreviation-tips.nix { };
  gitnow = pkgs.callPackage ./fish-plugins/gitnow.nix { };
  vk_hdr_layer = pkgs.callPackage ./vk-hdr-layer { };
  cups-brother-hl3152cdw = pkgs.callPackage ./hl3152cdw { };
}
