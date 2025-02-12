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
# Create the 'format' shell.
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = [
    (
      { pkgs, config, ... }:
      {
        packages = [
          pkgs.${namespace}.treefmt
        ];
      }
    )
  ];
}
