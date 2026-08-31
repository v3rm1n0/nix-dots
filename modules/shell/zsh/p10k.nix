_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      hostUsernames,
      ...
    }:
    {
      config = lib.mkIf config.mods.shell.zsh.enable (
        lib.mkMerge (
          map (username: {
            hjem.users.${username}.files.".config/zsh/.p10k.zsh".source = ./p10k.zsh;
          }) hostUsernames
        )
      );
    };
}
