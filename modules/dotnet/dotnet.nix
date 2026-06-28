{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.dotnet;
in {
  options.custom.dotnet = {
    enable = mkEnableOption "the .NET 11 SDK and C# development tooling";

    package = mkOption {
      type = types.package;
      default = pkgs.dotnet-sdk_11;
      defaultText = literalExpression "pkgs.dotnet-sdk_11";
      description = "The .NET SDK package to install system-wide.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      pkgs.dotnet-runtime_11
      pkgs.dotnet-aspnetcore_11
      pkgs.roslyn-ls
    ];
  };
}
