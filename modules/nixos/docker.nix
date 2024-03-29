_: {
  virtualisation.docker = {
    # enable = true;
    enableOnBoot = false;
    liveRestore = false;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    #enableNvidia = true;
  };
}
