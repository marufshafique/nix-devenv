{
  description = "Pi Coding Agent — devenv environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      ...
    }@inputs:
    {
      devShells = builtins.mapAttrs (system: pkgs: {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [ ./devenv.nix ];
        };
      }) nixpkgs.legacyPackages;
    };
}
