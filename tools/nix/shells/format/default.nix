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
    (args: {
      packages = [
        pkgs.${namespace}.treefmt
      ];
    })
  ];
}
