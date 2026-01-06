{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs; # Options: pkgs.emacs29, pkgs.emacs-pgtk, etc.
    
    # This allows you to manage your init file directly in Nix if you wish
    # extraConfig = ''
    #   (setq inhibit-startup-screen t)
    # '';
  };

  # Optional: Runs Emacs as a user-level systemd service
  services.emacs.enable =false;
}
