{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  security.apparmor.enable = true;
}
