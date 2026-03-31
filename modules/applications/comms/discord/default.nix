{ inputs, self, ... }:
{
  flake.nixosModules.applicationsCommsDiscord =
    { config, lib, ... }:
    let
      inherit (config.userOptions) username;
    in
    {
      home-manager.users.${username} = {
        imports = [ inputs.nixcord.homeModules.nixcord ];
        programs.nixcord = {
          enable = true;
          discord.enable = lib.mkDefault false;
          equibop.enable = lib.mkDefault true;
          config = {
            plugins = {
              betterFolders = {
                enable = true;
                closeOthers = true;
                sidebar = false;
              };
              betterSessions.enable = true;
              callTimer = {
                enable = true;
                allCallTimers = true;
              };
              declutter.enable = true;
              fakeNitro.enable = true;
              gameActivityToggle.enable = true;
              gitHubRepos.enable = true;
              messageLatency.enable = true;
              moreUserTags.enable = true;
              musicControls.enable = true;
              permissionsViewer.enable = true;
              platformIndicators.enable = true;
              quoter.enable = true;
              roleColorEverywhere.enable = true;
              sendTimestamps.enable = true;
              showHiddenChannels.enable = true;
              showHiddenThings.enable = true;
              showMeYourName.enable = true;
              youtubeAdblock.enable = true;
            };
            themeLinks = [
              "https://raw.githubusercontent.com/shvedes/discord-gruvbox/refs/heads/main/gruvbox-dark.theme.css"
            ];
          };
        };
      };
    };
}
