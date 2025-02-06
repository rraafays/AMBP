{ pkgs, ... }:

let
  STATE_VERSION = "24.11";
  DARWIN_STATE_VERSION = 6;
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-${STATE_VERSION}.tar.gz";
in
{
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
  environment.systemPackages = [ pkgs.vim ];
  system.stateVersion = DARWIN_STATE_VERSION;
  imports = [
    "${home-manager}/nix-darwin"
    ./modules/environment
    ./modules/home
  ];

  users.users.raf = {
    name = "raf";
    home = "/Users/raf";
  };
}
