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
  inherit inputs;
  pkgs = inputs.nixpkgsDevenv.legacyPackages.${pkgs.system};
  modules = toolchains.default;
}
