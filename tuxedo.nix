{ config, pkgs, ... }:
let
  tuxedo = import (builtins.fetchTarball "https://github.com/sund3RRR/tuxedo-nixos/archive/master.tar.gz");
in {

  imports = [
    tuxedo.outputs.nixosModules.default
  ];

  nixpkgs.overlays = [ tuxedo.outputs.overlays.default ];
  hardware = {
    tuxedo-drivers.enable = true;
    tuxedo-control-center.enable = true;
  };

  services.power-profiles-daemon.enable = false;
}
