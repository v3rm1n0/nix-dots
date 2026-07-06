_: {
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        acpi
        bat
        bat-extras.batman
        clang
        deadnix
        eza
        gh
        glow
        nixd
        nixfmt
        statix
        tirith
        unzip
        zoxide
      ];
    };
}
