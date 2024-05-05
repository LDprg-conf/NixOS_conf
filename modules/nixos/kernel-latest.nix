{ pkgs, ... }: {
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.kernel.sysctl = {
    "kernel.sysrq" =
      1; # Enable SysRQ for rebooting the machine properly if it freezes. [Source](https://oglo.dev/tutorials/sysrq/index.html)
  };
}
