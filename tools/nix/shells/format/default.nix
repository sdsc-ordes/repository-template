{
  inputs,
  lib,
  pkgs,
  namespace,
  ...
}:
lib.${namespace}.makeShell {
  inherit inputs;
  inherit (pkgs) system;
  modules = [
    {
      packages = [
        pkgs.${namespace}.treefmt
      ];
    }
  ];
}
