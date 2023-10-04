{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  networking.firewall.enable = true;
}
