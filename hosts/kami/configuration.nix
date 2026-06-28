{
  config,
  inputs,
  unstable,
  pkgs,
  modulesDir,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    (modulesDir + "/global/default.nix")
    (modulesDir + "/system/default.nix")
  ];

  #networking.hostName = "nixos";

  # Specific apps just for this machine
  environment.systemPackages = with pkgs; [
    # firefox
    kitty
    unstable.hyprland
    # inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    unstable.hyprcursor
    rofi
    dmenu
    nautilus
    swaybg
  ];
  programs.nano.enable = false;
  environment.sessionVariables.EDITOR = "nvim";

  custom.pythonDev.enable = true;
  custom.dotnet.enable = true;

  custom.unstable.enable = true;
  custom.opencode.enable = true;
  custom.windowsVm.enable = true;
  system.stateVersion = "25.11";

  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        # The entire Kanata layout configuration text goes directly into 'config'
        config = ''
          (defsrc caps)
          (defalias
          ;; Tapped: esc
          ;; Held: fires the macro (taps esc) and holds lctl down simultaneously
          capsec (tap-hold 1 5 esc (multi (macro esc) lctl))
          )

          (deflayer default @capsec)'';
      };
    };
  };

}
