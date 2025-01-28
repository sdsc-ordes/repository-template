# This function defines attrsets with packages
# to be used in the different development shells
# in this folder.

# Search for package at:
# https://search.nixos.org/packages
{
  pkgs,
  ...
}:
{
  packages = [
    pkgs.python313
    pkgs.ruff
    pkgs.uv
  ];

  shellHook = ''
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
}
