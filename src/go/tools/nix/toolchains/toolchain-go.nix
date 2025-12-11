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
    {
      repotemp.languages.go = {
        enable = true;
        inherit package;

        tools.packages = [
          # Go specific tools which should be compiled with the chosen
          # go `package`. Default is set to `tools.packagesDefaults`.
        ];

      };

      packages = [
        pkgs.golangci-lint
        pkgs.golangci-lint-langserver
      ];

      enterShell = ''
        just setup
      '';
    }
  ];
}
