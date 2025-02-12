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
# Create the 'bootstrap' shell.
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = [
    (
      { pkgs, config, ... }:
      {
        packages = [
          pkgs.${namespace}.bootstrap
          pkgs.${namespace}.treefmt
        ];
      }
    )
  ];
}
