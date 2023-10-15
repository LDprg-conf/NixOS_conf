{ self, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.preload;
  preload = self.packages.${pkgs.system}.preload;
in {
  meta = { maintainers = preload.meta.maintainers; };

  ###### interface
  options = {
    services.preload = { enable = mkEnableOption (lib.mdDoc "preload"); };
  };

  ###### implementation
  config = mkIf cfg.enable {
    systemd.services.preload = {
      description = "preload daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        EnvironmentFile = "${preload}/etc/conf.d/preload";
        ExecStart = "${getExe preload} --foreground $PRELOAD_OPTS";
        Type = "simple";
        IOSchedulingClass = 3;
        StateDirectory = "preload";
        StateDirectoryMode = "0750";
        LogsDirectory = "preload";
        LogsDirectoryMode = "0750";
      };
    };
  };
}
