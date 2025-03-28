{
  inputs,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  toolchains = import ../toolchain.nix { inherit pkgs namespace inputs; };
in
lib.${namespace}.makeShell {
  inherit inputs;
  inherit (pkgs) system;
  modules = toolchains.ci;
}
