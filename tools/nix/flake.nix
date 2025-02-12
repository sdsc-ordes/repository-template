{
  description = "repository-template";

  nixConfig = {
    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs repository.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nixpkgs repository on stable.
    nixpkgsStable.url = "github:nixos/nixpkgs/nixos-24.11";

    # The devenv module to create good development shells.
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Format the repo with nix-treefmt.
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall provides a structured way of creating a flake output.
    # Documentation: https://snowfall.org/guides/lib/quickstart/
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      # The `src` must be the root of the flake.
      src = ../..;

      snowfall = {
        root = ./.;
        namespace = "repository-template";
        meta = {
          name = "repository-template";
          title = "Repository Template";
        };
      };
    };
}
