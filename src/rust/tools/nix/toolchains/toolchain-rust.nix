# This function returns a attrset of `devenv` modules
# which can be passed to `mkShell`.
{
  self',
  pkgs,
  ...
}:
{
  rust = [
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
          toolchainPackage = self'.packages.rust-toolchain;
        };

        env = {
          CARGO_TARGET_DIR = "${config.devenv.root}/build";
        };

      }
    )
  ];
}
