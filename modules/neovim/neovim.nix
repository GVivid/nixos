{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.neovimPkg;
in
{
  options.programs.neovimPkg = {
    enable = mkEnableOption "Neovim package configuration";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      extraPackages = with pkgs; [
        nixpkgs-fmt
        nil
      ]; # Formatter + LSP server for Nix
    };
  };
}
