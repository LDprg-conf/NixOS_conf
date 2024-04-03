_: {
  virtualisation.docker = {
    enableOnBoot = false;
    liveRestore = false;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
