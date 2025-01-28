{
  inputs,
  namespace,
  pkgs,
  ...
}@args:
let
  toolchains = import ../toolchain.nix { inherit pkgs namespace inputs; };
in
# Create the 'default' shell.
pkgs.mkShell {
  packages = toolchains.default;

  shellHook = ''
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
}
