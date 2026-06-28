{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.custom.neovim;
in
{
  options.custom.neovim = {
    enable = mkEnableOption "Neovim package configuration";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.neovim-unwrapped;
      extraPackages = with pkgs; [
        nixpkgs-fmt
        nil
      ]; # Formatter + LSP server for Nix
    };
  };
}
