{
  lib,
  inputs,
  self,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      rust = lib.genAttrs [ "shell" "release" ] (
        name:
        let
          pkgsRust = pkgs.extend (import inputs.rust-overlay);
          toolchainFile = self.lib.fs.repoRoot + "/tools/configs/rust/rust-toolchain-${name}.toml";
          toolchain = pkgsRust.pkgsBuildHost.rust-bin.fromRustupToolchainFile toolchainFile;
          platform = pkgs.makeRustPlatform {
            cargo = toolchain;
            rustc = toolchain;
          };
        in
        {
          inherit toolchain platform;
        }
      );
    in
    {
      legacyPackages = {
        inherit rust;
      };
    };
}
