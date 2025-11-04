# This function returns a list of `devenv` modules
# which are passed to `mkShell`.
{
  # These are `pkgs` from `input.nixpkgs`.
  self',
  pkgs,
  ...
}:
let
  package = pkgs.go_1_25;
in
{
  go = [
    (
      { config, ... }:
      {
        packages = [
          # Go.
          package

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

        hardeningDisable = "fortify";

        env.GOROOT = package + "/share/go/";
        env.GOPATH = config.env.DEVENV_STATE + "/go";
        env.GOTOOLCHAIN = "local";

        enterShell = ''
          export PATH=$GOPATH/bin:$PATH
          just setup
        '';
      }
    )
  ];
}
