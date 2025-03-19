{
  inputs,
  pkgs,
  namespace,
  lib,
  ...
}:
let

  # TODO: Load essential fileset for the repo (./tools/nix)
  # to runAsRoot bootstrap all tools in the nix image below.

  # This is the Nix base image.
  nixImageBase = import (inputs.nix.outPath + "/docker.nix") {
    pkgs = pkgs;
    name = "devcontainer-nix-base";
    tag = "latest";

    bundleNixpkgs = false;

    extraPkgs = [ ];

    nixConf = {
      cores = "0";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
in

# Build the dev container
pkgs.dockerTools.buildLayeredImage {
  fromImage = nixImageBase;
  name = "devcontainer";
  tag = "latest";

  maxLayers = 104;

  contents = [ pkgs.${namespace}.bootstrap ];
  config = {
    WorkingDir = "/workspace";
    Volumes = {
      "/workspace" = { };
    };
    User = "root";
  };
}
