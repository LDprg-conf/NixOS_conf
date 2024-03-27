# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, user, host, lib, config, pkgs, spotx, ... }: {
  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-25.9.0" ];
    };
    overlays = [
      (_: prev: {
        spotify = prev.spotify.overrideAttrs (attrs: {
          buildInputs = [ prev.perl prev.unzip prev.zip ];
          postInstall = (attrs.postInstall or "") + ''
                cp ${spotx}/spotx.sh spotx.sh
                chmod +x spotx.sh
            	  bash spotx.sh -P $out/share/spotify/ -ch
            	'';
        });
      })
      (_: prev: {
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

  environment.systemPackages = with pkgs; [
    btop
    btrfs-progs
    cachix
    cdrkit
    compsize
    cryptsetup
    curl
    exfatprogs
    f2fs-tools
    gh
    git
    hfsprogs
    htop
    iftop
    inputs.nixos-needsreboot.packages.${system}.default
    iotop
    jfsutils
    killall
    lshw
    lvm2
    neofetch
    neovim
    nethogs
    nilfs-utils
    p7zip
    pciutils
    powertop
    progress
    ranger
    rar
    reiser4progs
    reiserfsprogs
    ripgrep
    rsync
    screen
    snapper
    tmux
    tree
    udftools
    unrar
    unzip
    usbutils
    util-linux
    uutils-coreutils
    vim
    wget
    xfsprogs
    xz
    zip
    zoxide
  ];

  services.fwupd.enable = true;

  hardware.enableAllFirmware = true;

  services.dbus.implementation = "broker";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
