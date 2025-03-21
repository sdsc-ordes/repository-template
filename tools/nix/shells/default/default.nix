{
  inputs,
  namespace,
  pkgs,
  ...
}:
let
  toolchains = import ../toolchain.nix { inherit pkgs namespace inputs; };
in
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = toolchains.default;
}
