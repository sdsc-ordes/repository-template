# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  pkgs,
  namespace,
  ...
}:
let
  # Packages for the 'default' shell.
  default = {
    packages = with pkgs; [
      # Stuff you always want ==============================
      pkgs.${namespace}.bootstrap
      pkgs.${namespace}.treefmt
      # ====================================================

      skopeo

      uv
      python313
      yq
    ];

    env = {
      RUFF_CACHE_DIR = ".output/cache/ruff";
    };

    enterShell = ''
      just setup
      source ./tools/scripts/activate-env.sh
    '';
  };

  # Packages for the 'ci' shell.
  ci = default;
in
{
  inherit default ci;
}
