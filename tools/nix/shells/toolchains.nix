# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  pkgs,
  namespace,
}:
let
  # Packages for the 'default' shell.
  default = with pkgs; [
    # Stuff you always want ==============================
    pkgs.${namespace}.bootstrap
    pkgs.${namespace}.treefmt

    coreutils
    findutils
    direnv # Auto apply stuff on entering directory `cd`.
    just # Command executor like `make` but better.
    # ====================================================
  ];

  # Packages for the 'ci' shell.
  ci = default ++ [
    # Stuff for CI.
  ];

in
{
  inherit default ci;
}
