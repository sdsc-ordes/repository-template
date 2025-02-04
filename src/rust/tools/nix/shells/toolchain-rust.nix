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
