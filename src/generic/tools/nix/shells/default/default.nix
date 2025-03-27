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
inputs.devenv.lib.mkShell {
  inherit inputs;
  pkgs = inputs.nixpkgsDevenv.legacyPackages.${pkgs.system};
  modules = toolchains.default;
}
