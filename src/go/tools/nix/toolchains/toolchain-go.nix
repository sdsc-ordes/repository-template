# This function returns a list of `devenv` modules
# which are passed to `mkShell`.
{
  # These are `pkgs` from `input.nixpkgs`.
  self',
  pkgs,
  ...
}:
{
  go = [
    {
      packages = [
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
  ];
}
