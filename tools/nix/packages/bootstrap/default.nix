{
  inputs,
  pkgs,
  lib,
  ...
}:
# The bootstrap packages with all tools
# to install over `nix profile install` before
# using `nix develop` which is the primary
# thing used here.
pkgs.buildEnv {
  name = "bootstrap";
  paths = [
    (lib.hiPrio pkgs.git)
    pkgs.git-lfs
    pkgs.just
  ];
}
