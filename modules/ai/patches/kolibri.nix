_: {
  # Aleph Alpha Kolibri-1 (arch `kolibri1`) is not in upstream llama.cpp yet
  # (https://github.com/ggml-org/llama.cpp/issues/29922). Until it lands, build a
  # patched llama.cpp for this one model only; every other model keeps the cached build.
  # Drop this file once nixpkgs ships a llama.cpp that supports kolibri1.
  flake.modules.nixos.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.mods.apps.ai.llama.kolibri;

      # Reviewed 2026-10-09: the full patch touches the model graph, the GGUF converter and
      # the tokenizer table. Only the src/ changes are needed to serve the model; the Python
      # converter and test hunks are dropped because conversion/base.py does not apply to
      # llama.cpp 0.5.0. Pinned to a repo revision so the hash cannot drift.
      patch = pkgs.fetchpatch {
        name = "kolibri1-llama.cpp.patch";
        url = "https://huggingface.co/Hob-forge/Kolibri-1-GGUF/resolve/40eaa5cf6cfca3afaf8b8832bac962652edb0bde/kolibri1-llama.cpp.patch";
        hash = "sha256-OklSDoIRBPS9d7TbVWuFyLxDtmanuAujyX1r6GrxZks=";
        excludes = [
          "conversion/*"
          "convert_hf_to_gguf_update.py"
          "gguf-py/*"
          "tests/*"
        ];
      };

      # Same CUDA toolkit derivations as pkgs, but kernels only for the RTX 3060,
      # which cuts the from-source build from nine GPU architectures to one.
      cudaPkgs = import pkgs.path {
        inherit (pkgs.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = [ cfg.cudaCapability ];
        };
      };

      package = cudaPkgs.llama-cpp.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ patch ];
      });
    in
    {
      options.mods.apps.ai.llama.kolibri = {
        enable = lib.mkEnableOption "Aleph Alpha Kolibri-1 via a patched llama.cpp";

        cudaCapability = lib.mkOption {
          type = lib.types.str;
          default = "8.6";
          description = "CUDA compute capability to build kernels for (8.6 = RTX 3060).";
        };
      };

      config = lib.mkIf (config.mods.apps.ai.enable && config.mods.apps.ai.llama.enable && cfg.enable) {
        mods.apps.ai.llama.models.kolibri = {
          repo = "Hob-forge/Kolibri-1-GGUF";
          file = "Kolibri-1-Q4_K_M.gguf";
          size = 47454113472;
          # 50 layers, ~0.9 GB of experts each. 42 ran out of VRAM for the compute buffers;
          # 46 left 3.7 GB free (measured), so 43 should fit. Tune with nvidia-smi.
          nCpuMoe = lib.mkDefault 43;
          # sampling recommended by Aleph Alpha
          extraArgs = [
            "--temp 1.0"
            "--top-p 0.97"
            "--top-k 128"
          ];
          # Reasoning off: in the benchmark it passed 8/12 vs 6/12 with reasoning on, at about a
          # tenth of the tokens (12 s vs 180 s per task).
          env = [ ''LLAMA_ARG_CHAT_TEMPLATE_KWARGS={"reasoning_effort":"none"}'' ];
          # Clients such as playgrounds and editor plugins send reasoning_effort or their own
          # chat_template_kwargs, which turn thinking back on; force it off for every request.
          filters = {
            stripParams = "reasoning_effort, reasoning, enable_thinking";
            setParams.chat_template_kwargs.reasoning_effort = "none";
          };
          inherit package;
        };
      };
    };
}
