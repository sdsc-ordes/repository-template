{
  lib,
  pkgs,
  namespace,
  ...
}@args:
let
  toolchains = import ../toolchain.nix args;
in
pkgs.mkShell {
  packages = toolchains.ci;
}
