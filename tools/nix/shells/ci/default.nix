{
  inputs,
  namespace,
  pkgs,
  ...
}:
let
  toolchains = import ../toolchain.nix { inherit pkgs namespace inputs; };
in
pkgs.mkShell {
  packages = toolchains.ci;
}
