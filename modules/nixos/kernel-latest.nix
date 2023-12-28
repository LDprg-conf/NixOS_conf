{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    #---------------------------------------------------------------------
    #   Network and memory-related optimizationss for 32GB
    #---------------------------------------------------------------------
    "kernel.sysrq" =
      1; # Enable SysRQ for rebooting the machine properly if it freezes. [Source](https://oglo.dev/tutorials/sysrq/index.html)
    "net.core.rmem_default" = 262144;           # Default socket receive buffer size, improve network performance & applications that use sockets. Adjusted for 32GB RAM.
    "net.core.rmem_max" = 67108864;             # Maximum socket receive buffer size, determine the amount of data that can be buffered in memory for network operations. Adjusted for 32GB RAM.
    "net.core.wmem_default" = 262144;           # Default socket send buffer size, improve network performance & applications that use sockets. Adjusted for 32GB RAM.
    "net.core.wmem_max" = 67108864;             # Maximum socket send buffer size, determine the amount of data that can be buffered in memory for network operations. Adjusted for 32GB RAM.
    "net.core.default_qdisc" = "cake"; #  Enable BBR
    "net.ipv4.tcp_congestion_control" = "bbr"; # Enable BBR
    "net.ipv4.tcp_fastopen" = 3; # Allow TCP fast open
    "net.ipv4.tcp_mtu_probing" = 1; # Enable MTU probing
    "vm.swappiness" =
      5; # Adjust how aggressively the kernel swaps data from RAM to disk. Lower values prioritize keeping data in RAM. Adjusted for 32GB RAM.
    "vm.vfs_cache_pressure" =
      200; # Adjust vfs_cache_pressure (0-1000) to manage memory used for caching filesystem objects. Adjusted for 32GB RAM.
  };
}
