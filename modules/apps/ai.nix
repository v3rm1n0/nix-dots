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
      users = builtins.filter (n: builtins.elem "ai" userProfiles.${n}.apps) hostUsernames;
    in
    {
      config = lib.mkMerge (
        [
          (lib.mkIf (users != [ ]) {
            services.ollama = {
              enable = false;
              package = pkgs.ollama-cuda;
            };
          })
        ]
        ++ map (name: {
          hjem.users.${name} = {
            packages = with pkgs; [
              jq
              claude-code
              sox
            ];

            files.".claude/settings.json" = {
              generator = lib.generators.toJSON { };
              value = {
                "$schema" = "https://json.schemastore.org/claude-code-settings.json";
                extraKnownMarketplaces = {
                  superpowers-marketplace = {
                    source = {
                      source = "github";
                      repo = "obra/superpowers-marketplace";
                    };
                  };
                };
                enabledPlugins = {
                  "superpowers@claude-plugins-official" = true;
                };
                statusLine = {
                  command = "~/.claude/statusline.sh";
                  type = "command";
                };
                voice = {
                  enabled = true;
                  mode = "tap";
                };
              };
            };
          };
        }) users
      );
    };
}
