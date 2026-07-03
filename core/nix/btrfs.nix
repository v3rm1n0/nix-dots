_: {
  flake.nixosModules.coreNixBtrfs = {
    # Enable Btrfs auto-scrub weekly (for data integrity)
    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };

    # Scheduled Btrfs trim
    services.fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
