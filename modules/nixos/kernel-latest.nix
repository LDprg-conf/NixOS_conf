{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_6_5;
}
