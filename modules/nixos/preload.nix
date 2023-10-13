# flatpak service.
{ self, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.preload;
  pkgs = self.packages.${pkgs.system};
in {
  meta = {
    maintainers = pkgs.preload.meta.maintainers;
  };

  ###### interface
  options = {
    services.preload = {
      enable = mkEnableOption (lib.mdDoc "preload");
    };
  };
 
  ###### implementation
  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.preload ];

    services.dbus.packages = [ pkgs.preload ];

    systemd.packages = [ pkgs.preload ];
  };
}