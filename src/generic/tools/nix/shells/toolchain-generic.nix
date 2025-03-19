{ pkgs, namespace, ... }:
{
  devcontainer.enable = true;

  packages = [
    pkgs.${namespace}.bootstrap
    pkgs.${namespace}.treefmt
  ];
}
