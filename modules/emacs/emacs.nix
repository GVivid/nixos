{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.emacsPkg;
in {
  options.programs.emacsPkg = {
    enable = mkEnableOption "Emacs package configuration";
  };

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
    };
  };
}
