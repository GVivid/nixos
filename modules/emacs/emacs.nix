{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.emacs;
in {
  options.custom.emacs = {
    enable = mkEnableOption "Emacs package configuration";
  };

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
    };
  };
}
