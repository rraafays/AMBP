{ ... }:

let
  STATE_VERSION = "24.11";
  USER = "raf";
  DARWIN_STATE_VERSION = 5;

  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${STATE_VERSION}.tar.gz";
in
{
  home-manager.users.${USER}.home.stateVersion = "${STATE_VERSION}";

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
      unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
        inherit pkgs;
      };
    };
  };

  imports = [
    "${home-manager}/nix-darwin"
    ./modules/environment
    ./modules/home
    ./modules/fonts
    ./modules/firefox
    ./modules/darwin
  ];

  environment.darwinConfig = "/etc/nix-darwin/configuration.nix";

  users.users.raf = {
    name = "raf";
    home = "/Users/raf";
  };

  system = {
    stateVersion = DARWIN_STATE_VERSION;
    activationScripts.dotfiles = {
      text = ''
        if [ -L /root/.config ]; then
            rm /root/.config
        elif [ -d /root/.config ]; then
            rm -rf /root/.config
        fi
        ln -s /home/${USER}/.config /root/.config
        chown -R ${USER} /home/${USER}/.config
      '';
    };
  };
}
