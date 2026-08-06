{
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      toolchains.rust = [
        (
          { config, ... }:
          {
            packages = [
              pkgs.cargo-watch

              # Debugging
              pkgs.lldb_18
            ];

            languages.rust = {
              enable = true;
              toolchainPackage = self'.legacyPackages.rust.shell.toolchain;
            };

            env = {
              CARGO_TARGET_DIR = "${config.devenv.root}/build";
            };
          }
        )
      ];
    };
}
