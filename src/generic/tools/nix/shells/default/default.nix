{
  lib,
  pkgs,
  inputs,
  namespace,
  ...
}:
let
  toolchains = import ../toolchain.nix { inherit lib pkgs namespace; };
in
# Create the 'default' shell.
lib.${namespace}.shell.mkShell {
  inherit (pkgs) system;
  inherit inputs;
  modules = toolchains.default;
}
