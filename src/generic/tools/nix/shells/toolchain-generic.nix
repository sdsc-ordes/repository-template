{ pkgs, namespace, ... }:
[
  (
    { ... }:
    {
      packages = [
        pkgs.${namespace}.bootstrap
        pkgs.${namespace}.treefmt
      ];
    }
  )
]
