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
# Create the 'ci' shell.
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = toolchains.ci;
}
