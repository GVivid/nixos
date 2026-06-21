{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.vscodeCfg;
in {
  options.programs.vscodeCfg = {
    enable = mkEnableOption "Visual Studio Code with C# development extensions";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "vscode-extension-ms-dotnettools-csharp"
        "vscode-extension-ms-dotnettools-csdevkit"
        "vscode-extension-ms-dotnettools-vscode-dotnet-runtime"
        "vscode-extension-ms-dotnettools-vscodeintellicode-csharp"
      ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit
        ms-dotnettools.vscode-dotnet-runtime
        ms-dotnettools.vscodeintellicode-csharp
      ];
    };
  };
}
