{ config, pkgs, inputs, modulesDir, ... }:

{
  users.users.kami = {
    isNormalUser = true;
    description = "kami";
    extraGroups = [ "networkmanager" "wheel"];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs modulesDir; };
    users = {
      "kami" = import ./../home.nix;
    };
  };
}
