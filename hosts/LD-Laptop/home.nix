# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/default-apps.nix
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

  #services.flatpak = {
  #  packages = [
  #    "flathub.org:app/com.spotify.Client//stable"
  #  ];
  #  remotes = {
  #    "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
  #    "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
  #  };
  #};

  services.flatpak = {
    packages = [
      "flathub:app/de.shorsh.discord-screenaudio//stable"
      # "flathub-beta:app/org.chromium.Chromium//beta"
      # "flathub:app/com.usebottles.bottles//stable"
    ];
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" =
        "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
  };
}
