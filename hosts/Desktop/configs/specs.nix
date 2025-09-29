{ ... }:
{
  imports = [
    ./../../../modules
  ];

  specs = {
    gpu.enable = true;
    gpu.brand = "nvidia";
  };
}
