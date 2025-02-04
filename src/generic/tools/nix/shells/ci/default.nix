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
# Create the 'ci' shell.
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = [
    ({ pkgs, config, ... }: toolchains.ci)
  ];
}
