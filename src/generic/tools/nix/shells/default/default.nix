{
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}@args:
let
  toolchains = import ../toolchain.nix args;
in
# Create the 'default' shell.
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = [
    ({ pkgs, config, ... }: toolchains.default)
  ];
}
