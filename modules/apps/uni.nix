_: {
  flake.modules.nixos.default =
    {
      lib,
      pkgs,
      hostUsernames,
      userProfiles,
      ...
    }:
    let
      users = builtins.filter (n: builtins.elem "uni" userProfiles.${n}.apps) hostUsernames;
    in
    {
      config = lib.mkMerge (
        map (name: {
          hjem.users.${name}.packages = with pkgs; [
            texliveFull
          ];
        }) users
      );
    };
}
