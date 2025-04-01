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
      pkgs.${namespace}.rust-toolchain
      pkgs.cargo-watch

      # Debugging
      pkgs.lldb_18
    ];
    enterShell = ''
      repo_dir=$(git rev-parse --show-toplevel)
      # Set the default output directory.
      export CARGO_TARGET_DIR="$repo_dir/build"
      unset repo_dir

      just setup
    '';
  }
]
