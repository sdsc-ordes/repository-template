{
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      toolchains.go = [
        {
          repotemp.languages.go = {
            enable = true;
            package = pkgs.go_1_25;

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
    };
}
