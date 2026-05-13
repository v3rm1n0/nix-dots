_: {
  flake.nixosModules.coreHardwarePipewire =
    {
      config,
      pkgs,
      ...
    }:
    let
      username = config.userOptions.username;
      EQPathAirpods = ".config/pipewire/config/airpods.txt";
      EQPathTruthear = ".config/pipewire/config/truthear.txt";
    in
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
        pulse.enable = true;
      };
      environment.systemPackages = [ pkgs.crosspipe ];

      hjem.users.${username}.files = {
        ".config/pipewire/pipewire.conf.d/truthear-equalizer.conf".text = ''
          context.modules = [
            {
              name = "libpipewire-module-parametric-equalizer"
              args = {
                node.name = "parametric-equalizer-truthear"
                media.class = "Audio/Sink"
                equalizer.filepath = "${EQPathTruthear}"
                equalizer.description = "EQ Truthear"
              }
            }
          ]
        '';
        ".config/pipewire/pipewire.conf.d/airpods-equalizer.conf".text = ''
          context.modules = [
            {
              name = "libpipewire-module-parametric-equalizer"
              args = {
                node.name = "parametric-equalizer-airpods"
                media.class = "Audio/Sink"
                equalizer.filepath = "${EQPathAirpods}"
                equalizer.description = "EQ AirPods"
              }
            }
          ]
        '';
        ".config/pipewire/config".source = ./configs;
      };
    };
}
