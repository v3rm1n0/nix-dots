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
      users = builtins.filter (n: builtins.elem "comms" userProfiles.${n}.apps) hostUsernames;
    in
    {
      config = lib.mkMerge (
        map (name: {
          hjem.users.${name} = {
            packages = with pkgs; [
              protonmail-desktop
              sable
              signal-desktop
              teamspeak6-client
              thunderbird
              zoom-us
            ];
          };
        }) users
      );
    };
}
