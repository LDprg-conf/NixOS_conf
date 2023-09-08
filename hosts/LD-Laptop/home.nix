# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/default-apps.nix
    flatpak.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    kate
    thunderbird
    helvum
    easyeffects
    protonup-qt
    whatsapp-for-linux
    signal-desktop
    quickemu
    element-desktop
    gitkraken
  ];

  services.flatpak = {
    packages = [
      "flathub:org.kde.index//stable"
      "flathub-beta:org.kde.kdenlive/x86_64/stable"
    ];
    remotes = {
      "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
  };
}
