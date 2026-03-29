{ self, inputs, ... }:
{
  flake.nixosModules.coreProgramsUtilsLocalsend =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [ localsend ];
    };
}
