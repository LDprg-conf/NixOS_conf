{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: {
  imports = [
    ../../modules/nixos/default-apps.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/fish.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/kernel-latest.nix
    ../../modules/nixos/libreoffice.nix
    ../../modules/nixos/firewall.nix
    ../../modules/nixos/ananicy.nix
    ../../modules/nixos/apparmor.nix
    ../../modules/nixos/docker.nix

    ./hardware.nix

    ../../modules/nixos/plasma.nix
  ];

  nixpkgs.overlays = [ nix-your-shell.overlays.default ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  users.users.ld = {
    description = "LD";
    shell = pkgs.fish;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  environment.systemPackages = with pkgs;
    [
      wayland-utils
      clinfo
      openrgb
      mangohud
      git
      pre-commit
      esptool
      antimicrox
      nix-your-shell
      cifs-utils
      samba
      simple-http-server
    ] ++ (with self.packages.${pkgs.system};
      [
        jdownload2
        # printer-driver-ptouch 
      ]);

  services.hardware.bolt.enable = true;

  services.udev.packages = [ pkgs.openrgb ];
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  hardware.i2c.enable = true;

  security.polkit.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.preload.enable = true;

  # programs.darling.enable = true;

  services.logmein-hamachi.enable = true;
  programs.haguichi.enable = true;

  programs.gamescope.enable = true;

  boot.loader.timeout = 2;

  hardware.nvidia.prime = {
    sync.enable = true;

    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      ubuntu_font_family

      fira-code
      fira-code-symbols
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "FiraCode" ];
      };
    };
  };

  powerManagement.enable = true;
  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    general = {
      renice = 0;
      ioprio = ''"off"'';
    };
  };

  hardware.bluetooth.enable = true;

  services.joycond.enable = true;
}
