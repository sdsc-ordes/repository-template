{
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}:
# Create the 'format' shell.
lib.${namespace}.shell.mkShell {
  inherit (pkgs) system;
  inherit inputs;
  modules = [
    (
      { pkgs, ... }:
      {
        packages = [
          pkgs.${namespace}.treefmt
        ];
      }
    )
  ];
}
