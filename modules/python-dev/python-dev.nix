{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.pythonDev;
in {
  options.programs.pythonDev = {
    enable = mkEnableOption "the modern Python development stack (Python, uv, ty, and ruff)";
    
    package = mkOption {
      type = types.package;
      default = pkgs.python3;
      defaultText = literalExpression "pkgs.python3";
      description = "The core Python package to install system-wide.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      pkgs.uv    # Fast Python package installer and resolver
      pkgs.ty    # Astral's extremely fast Rust-based static type checker
      pkgs.ruff  # Fast Python linter and formatter
    ];
  };
}
