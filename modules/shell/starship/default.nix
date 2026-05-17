{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.starship = inputs.wrapper-modules.wrappers.starship.wrap {
        inherit pkgs;
        package = pkgs.starship;
        #preset = [ "pure-preset" ];
        settings = {
          format = "[╭─](242)$os$directory$git_branch$git_status$fill$status$cmd_duration$jobs$direnv$nix_shell\n[╰─](242) $character";
          add_newline = false;

          os = {
            disabled = false;
            format = "[$symbol]($style)";
            style = "bold";
          };

          os.symbols = {
            NixOS = " ";
          };

          directory = {
            format = "[$path]($style)[$read_only]($read_only_style) ";
            style = "bold 31";
            read_only = " 󰌾";
            read_only_style = "196";
            truncation_length = 3;
            truncate_to_repo = true;
            fish_style_pwd_dir_length = 1;
            truncation_symbol = "…/";
          };

          git_branch = {
            format = "[$symbol$branch]($style) ";
            symbol = " ";
            style = "bold 76";
            truncation_length = 32;
            truncation_symbol = "…";
          };

          git_status = {
            format = "([$all_status$ahead_behind]($style))";
            style = "bold";
            staged = " [+$count](178)";
            modified = " [!$count](178)";
            untracked = " [?$count](39)";
            conflicted = " [~$count](196)";
            stashed = " [*$count](76)";
            deleted = "";
            renamed = "";
            ahead = " [⇡$count](76)";
            behind = " [⇣$count](76)";
            diverged = " [⇣$behind_count⇡$ahead_count](76)";
          };

          character = {
            success_symbol = "[❯](bold 76)";
            error_symbol = "[❯](bold 196)";
            vimcmd_symbol = "[❮](bold 76)";
            vimcmd_replace_one_symbol = "[❮](bold 76)";
            vimcmd_replace_symbol = "[❮](bold 76)";
            vimcmd_visual_symbol = "[V](bold 76)";
          };

          status = {
            disabled = false;
            format = "[$symbol$status]($style) ";
            style = "bold 160";
            symbol = "✘";
            success_symbol = "";
            map_symbol = true;
            pipestatus = true;
          };

          cmd_duration = {
            min_time = 3000;
            format = "[$duration]($style) ";
            style = "101";
            show_milliseconds = false;
          };

          jobs = {
            disabled = false;
            format = "[$symbol]($style) ";
            symbol = "⚙";
            style = "70";
            number_threshold = 1;
            symbol_threshold = 1;
          };

          direnv = {
            disabled = false;
            format = "[$symbol$loaded/$allowed]($style) ";
            symbol = "direnv ";
            style = "bold 178";
            allowed_msg = "allowed";
            not_allowed_msg = "denied";
            loaded_msg = "loaded";
            unloaded_msg = "not loaded";
          };

          nix_shell = {
            format = "[$symbol$state]($style) ";
            symbol = "❄️ ";
            style = "bold 39";
          };

          fill.symbol = " ";
        };
      };
    };
}
