{
  lib,
  pkgs,
  namespace,
  ...
}@args:
let
  toolchains = import ../toolchain.nix args;
in
# Create the 'default' shell.
pkgs.mkShell {
  packages = toolchains.default.packages;
  shellHook = toolchains.default.shellHook;
}
