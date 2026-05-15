{ inputs, self, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      myAliases = self.lib.commonAliases;
    in
    {
      packages.fish = inputs.wrapper-modules.wrappers.fish.wrap {
        inherit pkgs;
        package = pkgs.fish;
        configFile.content = ''
          function fish_prompt
              set -l s $status
              set -l gray (set_color 6C6C6C)
              set -l reset (set_color normal)

              # Line 1: ╭─ [dir] [git]
              echo -ns $gray'╭─ '

              # Directory — anchors bright blue, truncated dirs dim blue
              echo -ns (set_color 5f87ff)(prompt_pwd --full-length-dirs=1)$reset

              # Git status
              if command git rev-parse --git-dir &>/dev/null 2>&1
                  set -l branch (command git symbolic-ref --short HEAD 2>/dev/null
                                 or command git rev-parse --short HEAD 2>/dev/null)
                  if test -n "$branch"
                      echo -ns '  '
                      set -l staged (command git diff --cached --name-only 2>/dev/null | count)
                      set -l dirty  (command git diff --name-only 2>/dev/null | count)
                      set -l untracked (command git ls-files --others --exclude-standard 2>/dev/null | count)
                      if test $staged -gt 0
                          echo -ns (set_color af8700)$branch' ~'$staged
                      else if test $dirty -gt 0 -o $untracked -gt 0
                          echo -ns (set_color af8700)$branch' !'(math $dirty + $untracked)
                      else
                          echo -ns (set_color 5faf00)$branch
                      end
                  end
              end

              echo

              # Line 2: ╰─❯
              echo -ns $gray'╰─'
              if test $s -eq 0
                  echo -ns (set_color 5fd700)'❯'
              else
                  echo -ns (set_color FF0000)'❯'
              end
              echo -ns $reset' '
          end

          function fish_right_prompt
              set -l s $status
              set -l reset (set_color normal)

              # Exit code (only on failure)
              if test $s -ne 0
                  echo -ns (set_color FF0000)' '$s$reset
              end

              # Command duration (>3s)
              if test $CMD_DURATION -gt 3000
                  set -l secs (math --scale=1 $CMD_DURATION / 1000)
                  echo -ns (set_color af8700)' '$secs's'$reset
              end

              # Background jobs
              set -l jobs (jobs | count)
              if test $jobs -gt 0
                  echo -ns (set_color 5f87ff)' ⚙'$jobs$reset
              end
          end

          # Shell integrations
          ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
          ${lib.getExe pkgs.direnv} hook fish | source
          ${lib.getExe pkgs.tirith} init --shell fish | source
          ${lib.getExe pkgs.zoxide} init fish --cmd cd | source
        '';
        plugins = with pkgs.fishPlugins; [
          bass
          fzf-fish
        ];
        shellAliases = myAliases;
      };
    };
}
