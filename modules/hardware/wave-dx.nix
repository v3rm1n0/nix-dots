_: {
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.hardware.waveDx;
      username = config.userOptions.username;
      ladspa = "${pkgs.ladspaPlugins}/lib/ladspa";
    in
    {
      options.mods.hardware.waveDx = {
        enable = lib.mkEnableOption "Elgato Wave DX voice chain";
        source = lib.mkOption {
          type = lib.types.str;
          default = "alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y73JWBD5A10888-00.HiFi__Mic1__source";
          description = "Raw interface input the Wave DX is plugged into";
        };
        gain = lib.mkOption {
          type = lib.types.float;
          default = 17.8;
          description = "Linear pre-gain (17.8 = +25 dB), the DX needs more than the Solo preamp gives";
        };
      };

      config = lib.mkIf cfg.enable {
        # HPF -> EQ -> gain -> gate -> compressor -> limiter
        hjem.users.${username}.files.".config/pipewire/pipewire.conf.d/wave-dx.conf".text = ''
          context.modules = [
            {
              name = libpipewire-module-filter-chain
              args = {
                node.description = "Wave DX"
                media.name = "Wave DX"
                audio.rate = 48000
                audio.channels = 1
                audio.position = [ MONO ]
                filter.graph = {
                  nodes = [
                    { type = builtin name = hpf  label = bq_highpass  control = { "Freq" = 80.0 "Q" = 0.707 } }
                    { type = builtin name = mud  label = bq_peaking   control = { "Freq" = 300.0 "Q" = 1.0 "Gain" = -2.0 } }
                    { type = builtin name = pres label = bq_peaking   control = { "Freq" = 4500.0 "Q" = 0.8 "Gain" = 3.0 } }
                    { type = builtin name = air  label = bq_highshelf control = { "Freq" = 10000.0 "Q" = 0.707 "Gain" = 2.0 } }
                    { type = builtin name = gain label = linear       control = { "Mult" = ${toString cfg.gain} "Add" = 0.0 } }
                    # builtin noisegate never opens (unconnected Level port reads 0), use swh gate
                    {
                      type = ladspa name = gate plugin = "${ladspa}/gate_1410.so" label = gate
                      control = {
                        "LF key filter (Hz)" = 100.0
                        "HF key filter (Hz)" = 8000.0
                        "Threshold (dB)" = -36.0
                        "Attack (ms)" = 2.0
                        "Hold (ms)" = 200.0
                        "Decay (ms)" = 150.0
                        "Range (dB)" = -25.0
                      }
                    }
                    {
                      type = ladspa name = comp plugin = "${ladspa}/sc4m_1916.so" label = sc4m
                      control = {
                        "RMS/peak" = 0.0
                        "Attack time (ms)" = 10.0
                        "Release time (ms)" = 120.0
                        "Threshold level (dB)" = -20.0
                        "Ratio (1:n)" = 3.0
                        "Knee radius (dB)" = 6.0
                        "Makeup gain (dB)" = 4.0
                      }
                    }
                    {
                      type = ladspa name = lim plugin = "${ladspa}/fast_lookahead_limiter_1913.so" label = fastLookaheadLimiter
                      control = { "Input gain (dB)" = 0.0 "Limit (dB)" = -1.0 "Release time (s)" = 0.05 }
                    }
                  ]
                  links = [
                    { output = "hpf:Out"     input = "mud:In" }
                    { output = "mud:Out"     input = "pres:In" }
                    { output = "pres:Out"    input = "air:In" }
                    { output = "air:Out"     input = "gain:In" }
                    { output = "gain:Out"    input = "gate:Input" }
                    { output = "gate:Output" input = "comp:Input" }
                    { output = "comp:Output" input = "lim:Input 1" }
                  ]
                  inputs = [ "hpf:In" ]
                  outputs = [ "lim:Output 1" ]
                }
                capture.props = {
                  node.name = "capture.wave_dx"
                  node.passive = true
                  target.object = "${cfg.source}"
                  stream.dont-remix = true
                }
                playback.props = {
                  node.name = "wave_dx"
                  media.class = Audio/Source
                  priority.session = 2500
                }
              }
            }
          ]
        '';
      };
    };
}
