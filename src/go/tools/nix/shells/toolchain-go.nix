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

    # Go.
    pkgs.go_1_23

    # Go debugger.
    pkgs.delve
    # Language server.
    pkgs.gopls
    # Formatting
    pkgs.golines
    # Formatting (goimports)
    pkgs.gotools
    # Linting
    pkgs.golangci-lint
    pkgs.golangci-lint-langserver

    # Debugging
    pkgs.lldb_18
  ];
  enterShell = ''
    just setup
  '';
}
