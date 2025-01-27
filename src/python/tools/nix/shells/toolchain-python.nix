# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  pkgs,
  ...
}:
[
  pkgs.python313
  pkgs.ruff
  pkgs.uv
]
