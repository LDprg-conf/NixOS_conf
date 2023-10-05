{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  services.ananicy.package = pkgs.ananicy-cpp;
  services.ananicy.enable = true;

  services.ananicy.settings = {
    check_freq = 15;
    cgroup_load = true;
    type_load = true;
    rule_load = true;

    apply_nice = true;
    apply_latnice = true;
    apply_ioclass = true;
    apply_ionice = true;
    apply_sched = true;
    apply_oom_score_adj = true;
    apply_cgroup = true;

    check_disks_schedulers = true;
  };

  services.ananicy.extraRules = [
    # Type definitions
    #{
    #  type = "game";
    #  nice = -7;
    #  ioclass = "best-effort";
    #  latency_nice = -7;
    #}
    # CGroups
    {
      cgroup = "cpu90";
      CPUQuota = 90;
    }
    {
      cgroup = "cpu85";
      CPUQuota = 85;
    }
    {
      cgroup = "cpu80";
      CPUQuota = 80;
    }
    # Games
    {
      name = "eldenring.exe";
      type = "game";
    }
    # Game related stuff
    {
      name = "Steam.exe";
      type = "game-launcher";
    }
    {
      name = "steamwebhelper.exe";
      type = "BG_CPUIO";
    }
    {
      name = "steam";
      type = "game-launcher";
    }
    {
      name = "steamwebhelper";
      type = "BG_CPUIO";
    }
    {
      name = "game.x86_64";
      type = "game";
    }
    {
      name = "game.x86";
      type = "game";
    }
    {
      name = "runner";
      type = "game";
    }
    {
      name = "gamemoded";
      type = "service";
    }
    # Services
    {
      name = "bluetoothd";
      type = "service";
    }
    {
      name = "cups";
      type = "service";
    }
    {
      name = "thermald";
      type = "BG_CPUIO";
    }
    {
      name = "nextcloud";
      type = "file-sync";
    }
    # Terminals
    {
      name = "kitty";
      type = "terminal";
    }
    {
      name = "konsole";
      type = "terminal";
    }
    # Chats
    {
      name = "Discord";
      type = "chat";
    }
    {
      name = "signal-desktop";
      type = "chat";
    }
    {
      name = "telegram-desktop";
      type = "chat";
    }
    # DE & WM
    {
      name = "plasmashell";
      type = "DEWM";
    }
    {
      name = "kwin_x11";
      type = "DEWM";
    }
    {
      name = "kwin_wayland";
      type = "DEWM";
    }
    {
      name = "kwin_wayland_wrapper";
      type = "DEWM";
    }
    {
      name = "sddm";
      type = "DEWM";
    }
    {
      name = "sddm-helper";
      type = "DEWM";
    }
    {
      name = "Xorg";
      type = "DEWM";
    }
    {
      name = "Xwayland";
      type = "DEWM";
    }
    # Compiles
    {
      name = "cmake";
      type = "compiler";
    }
    {
      name = "g++";
      type = "compiler";
    }
    {
      name = "gcc";
      type = "compiler";
    }
    {
      name = "go";
      type = "compiler";
    }
    {
      name = "javac";
      type = "compiler";
    }
    {
      name = "ninja";
      type = "compiler";
    }
    {
      name = "meson";
      type = "compiler";
    }
    {
      name = "cargo";
      type = "compiler";
    }
    {
      name = "rustc";
      type = "compiler";
    }
    {
      name = "rust-analyzer";
      type = "compiler";
    }
    # Email
    {
      name = "thunderbird";
      type = "email-client";
    }
    # Music Players
    {
      name = "spotify";
      type = "music-player";
    }
    # VMs
    {
      name = "qemu-system-x86_64";
      type = "VM";
    }
    {
      name = "VirtualBoxVM";
      type = "VM";
    }
    {
      name = "vmware-vmx";
      type = "VM";
    }
    {
      name = "vmware";
      type = "VM";
    }
    # Browsers
    {
      name = "brave";
      type = "web-browser";
    }
    {
      name = "vivaldi-bin";
      type = "web-browser";
    }
    {
      name = "librewolf";
      type = "web-browser";
    }
    {
      name = "firefox";
      type = "web-browser";
    }
    {
      name = "firefox.real";
      type = "web-browser";
    }
    {
      name = "QtWebEngineProcess";
      type = "web-browser";
    }
    {
      name = "surf";
      type = "web-browser";
    }
    # Common Tools
    {
      name = "curl";
      type = "BG_CPUIO";
    }
    {
      name = "wget";
      type = "BG_CPUIO";
    }
    {
      name = "htop";
      type = "BG_CPUIO";
    }
    {
      name = "systemd-timesyncd";
      type = "BG_CPUIO";
    }
    # Audio Servers
    {
      name = "pipewire";
      type = "audio-server";
    }
    {
      name = "pipewire-pulse";
      type = "audio-server";
    }
    {
      name = "pulseaudio";
      type = "audio-server";
    }
    # Document
    {
      name = "oosplash";
      type = "document-editor";
    }
    {
      name = "soffice.bin";
      type = "document-editor";
    }
    # Editors
    {
      name = "kate";
      type = "document-editor";
    }
    {
      name = "code";
      type = "document-editor";
    }
    {
      name = "codium";
      type = "document-editor";
    }
    {
      name = "nano";
      type = "document-editor";
    }
    {
      name = "vim";
      type = "document-editor";
    }
    {
      name = "nvim";
      type = "document-editor";
    }
    # Core Utils
    {
      name = "cat";
      type = "BG_CPUIO";
    }
    {
      name = "cksum";
      type = "BG_CPUIO";
    }
    {
      name = "comm";
      type = "BG_CPUIO";
    }
    {
      name = "dd";
      type = "BG_CPUIO";
    }
    {
      name = "df";
      type = "BG_CPUIO";
    }
    {
      name = "du";
      type = "BG_CPUIO";
    }
    {
      name = "install";
      type = "BG_CPUIO";
    }
    {
      name = "join";
      type = "BG_CPUIO";
    }
    {
      name = "md5sum";
      type = "BG_CPUIO";
    }
    {
      name = "mkdir";
      type = "BG_CPUIO";
    }
    {
      name = "mv";
      type = "BG_CPUIO";
    }
    {
      name = "rm";
      type = "BG_CPUIO";
    }
    {
      name = "rmdir";
      type = "BG_CPUIO";
    }
    {
      name = "sha1sum";
      type = "BG_CPUIO";
    }
    {
      name = "sha256sum";
      type = "BG_CPUIO";
    }
    {
      name = "sha384sum";
      type = "BG_CPUIO";
    }
    {
      name = "sha512sum";
      type = "BG_CPUIO";
    }
    {
      name = "shred";
      type = "BG_CPUIO";
    }
    {
      name = "sort";
      type = "BG_CPUIO";
    }
    {
      name = "sum";
      type = "BG_CPUIO";
    }
    {
      name = "tac";
      type = "BG_CPUIO";
    }
    {
      name = "tee";
      type = "BG_CPUIO";
    }
    {
      name = "wc";
      type = "BG_CPUIO";
    }
  ];
}
