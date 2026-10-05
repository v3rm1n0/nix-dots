_: {
  flake.modules.nixos.default =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.userOptions) username;
      toml = pkgs.formats.toml { };

      # Notebook location; exported as ZK_NOTEBOOK_DIR for the CLI and zk-nvim.
      notesDir = "/home/${username}/notes";

      settings = {
        note = {
          language = "en";
          default-title = "Untitled";
          filename = "{{id}}-{{slug title}}";
          extension = "md";
          template = "default.md";
          id-charset = "alphanum";
          id-length = 4;
          id-case = "lower";
        };

        format.markdown = {
          link-format = "wiki";
          hashtags = true;
        };

        group.daily = {
          paths = [ "journal/daily" ];
          note = {
            filename = "{{format-date now '%Y-%m-%d'}}";
            template = "daily.md";
          };
        };

        lsp = {
          diagnostics = {
            wiki-title = "hint";
            dead-link = "error";
          };
          completion = {
            note-label = "{{title-or-path}}";
            note-filter-text = "{{title}} {{path}}";
          };
        };

        alias.daily = ''zk new --no-input "$ZK_NOTEBOOK_DIR/journal/daily"'';
      };
    in
    {
      environment.systemPackages = [ pkgs.zk ];
      environment.sessionVariables.ZK_NOTEBOOK_DIR = notesDir;

      systemd.tmpfiles.rules = [
        "d ${notesDir} 0755 ${username} users -"
        "d ${notesDir}/.zk 0755 ${username} users -"
        "d ${notesDir}/journal 0755 ${username} users -"
        "d ${notesDir}/journal/daily 0755 ${username} users -"
      ];

      hjem.users.${username}.files = {
        ".config/zk/config.toml".source = toml.generate "zk-config.toml" settings;
        ".config/zk/templates/default.md".text = ''
          # {{title}}

          {{content}}
        '';
        ".config/zk/templates/daily.md".text = ''
          # {{format-date now "long"}}

        '';
      };
    };
}
