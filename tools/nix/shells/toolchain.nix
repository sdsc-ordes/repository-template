# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  inputs,
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

      coreutils
      findutils
      direnv # Auto apply stuff on entering directory `cd`.
      just # Command executor like `make` but better.
      # ====================================================

      uv
      python313
      yq
    ];

    enterShell = ''
      just setup

      repo_dir=$(git rev-parse --show-toplevel)
      # We never want that uv manages python installs.
      export UV_PYTHON_DOWNLOADS=never

      venv_dir="$repo_dir/.venv"
      # Activate python environment.
      if [ -f "$venv_dir/bin/activate" ]; then
        echo "Activating python environment in '$venv_dir'."
        source "$venv_dir/bin/activate"
      fi

      unset venv_dir
      unset repo_dir
    '';
  };

  # Packages for the 'ci' shell.
  ci = default;
in
{
  inherit default ci;
}
