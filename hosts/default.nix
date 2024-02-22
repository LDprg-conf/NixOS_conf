# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, spotx, ... }: {
  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-25.9.0" ];
    };
    overlays = [
      (final: prev: {
        spotify = prev.spotify.overrideAttrs (attrs:
          {
            buildInputs = [ prev.perl prev.unzip prev.zip ];
            postInstall = (attrs.postInstall or "") + ''
                  cp ${spotx}/spotx.sh spotx.sh
                  chmod +x spotx.sh
              	  bash spotx.sh -P $out/share/spotify/ -ch
              	'';
          });
      })
      (final: prev: {
        gitkraken = prev.gitkraken.overrideAttrs (attrs:
          let
            patchScript = prev.fetchurl {
              url =
                "https://archive.org/download/gpatcher0.0.5/gpatcher0.0.5.zip";
              hash = "sha256-wPCLUTnjhwAgxjUQIzvpefxCA3JPX/h4QE70obdkPo0=";
            };
          in {
            buildInputs = [ prev.unzip ];

            postFixup = (attrs.postFixup or "") + ''
              unzip ${patchScript} -d gitcracken-patch
              cd gitcracken-patch

              chmod +w $out/share/gitkraken/resources

              ./gpatcher_linux_amd64 $out/share/gitkraken/resources/app.asar             
            '';
          });
      })
    ];
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    # Grabage Collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      warn-dirty = false;
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      trusted-users = [ "root" "ld" ];
    };
  };

  # TODO: Set your hostname
  networking.hostName = "${host}";

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  console.keyMap = "de";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
      "docker"
      "dialout"
      "scanner"
      "lp"
    ];
  };
  # users.users.test = {
  #   isNormalUser = true;
  #   extraGroups = [ "networkmanager" "wheel" "wireshark" "docker" "dialout" ];
  # };

  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    git
    gh
    neofetch
    ranger
    lshw
    unzip
    zip
    xz
    unrar
    rar
    curl
    htop
    btop
    killall
    ripgrep
    tree
    iftop
    iotop
    nethogs
    cachix
    pciutils
    rsync
    progress
    tmux
    screen
    usbutils
    uutils-coreutils
    exfatprogs
    xfsprogs
    f2fs-tools
    btrfs-progs
    compsize
    snapper
    util-linux
    cryptsetup
    reiserfsprogs
    hfsprogs
    jfsutils
    reiser4progs
    udftools
    nilfs-utils
    lvm2
    cdrkit
  ];

  services.fwupd.enable = true;
  services.irqbalance.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  services.dbus.implementation = "broker";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
