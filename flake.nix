{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # open PR adding the omniroute package and NixOS module, drop once merged.
    # Pinned to the commit in flake.lock instead of the mutable PR head ref so
    # evaluation is reproducible and survives the PR branch being rebased.
    nixpkgs-omniroute.url = "github:NixOS/nixpkgs/682096be7038a86337aafa8d213aa3364d204f9f";
    # open PR adding xtool (+ open-apple-macros, xtoolBuildHook) and the
    # programs.xtool module, drop once merged. Same pinning rationale as above.
    # https://github.com/NixOS/nixpkgs/pull/548520
    nixpkgs-xtool.url = "github:NixOS/nixpkgs/1acbd57769c1cd85e0a861c6708a10a9f7d18492";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    pergament.url = "github:v3rm1n0/pergament";
    bootvine = {
      url = "git+https://codeberg.org/wvhulle/bootvine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # pinned to the last release with the hyprlang config; 0.57+ moved to lua and nixpkgs lacks the parser
    hyprland.url = "github:hyprwm/Hyprland/v0.56.1";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hjem.follows = "hjem";
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wazuh-agent-nixos = {
      url = "git+https://github.com/nealfennimore/wazuh-agent-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers = {
      url = "github:Lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [
          (inputs.import-tree ./assets)
          (inputs.import-tree ./hosts)
          (inputs.import-tree ./modules)
        ];
      }
    );
}
