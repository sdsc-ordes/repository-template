{
  pkgs,
  namespace,
  ...
}:
let
  toolchains = import ../toolchains.nix { inherit pkgs namespace; };
in
pkgs.mkShell {
  packages = toolchains.ci;
}
