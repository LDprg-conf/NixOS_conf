{ pkgs, ... }: {
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  environment.systemPackages = [ pkgs.scx ];

  chaotic.scx = {
    enable = false;
    scheduler = "scx_rustland";
  };

  boot.kernel.sysctl = {
    "kernel.sysrq" =
      1; # Enable SysRQ for rebooting the machine properly if it freezes. [Source](https://oglo.dev/tutorials/sysrq/index.html)
  };
}
