# This function returns a list of `devenv` modules
# which are passed to `mkShell`.
#
# Search for package at:
# https://search.nixos.org/packages
{
  # These are `pkgs` from `input.nixpkgs`.
  pkgs,
  namespace,
  ...
}:
[
  {
    packages = [
      pkgs.${namespace}.bootstrap
      pkgs.${namespace}.treefmt
    ];
  }
]
