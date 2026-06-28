{ config, lib, inputs, unstable, pkgs, ... }:

with lib;

let
  cfg = config.custom.unstable;
in {
  options.custom.unstable = {
    enable = mkEnableOption "Unstable nixpkgs channel";
  };

  config = mkIf cfg.enable {
    _module.args.unstable = import inputs.unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };
  };
}
