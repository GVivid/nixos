{ config,inputs,unstable,pkgs, ... }:

{
  # This makes it so I can use unstable.package_name anywhere in the config
   _module.args.unstable = import inputs.unstable {
	inherit (pkgs.stdenv.hostPlatform) system;
	inherit (config.nixpkgs) config;
  };
}
