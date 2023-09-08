{ inputs, outputs, user, host, lib, config, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
