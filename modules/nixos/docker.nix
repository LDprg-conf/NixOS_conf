_: {
  virtualisation.docker = {
    # enable = true;
    #enableNvidia = true;
    enableOnBoot = false;
    liveRestore = false;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
