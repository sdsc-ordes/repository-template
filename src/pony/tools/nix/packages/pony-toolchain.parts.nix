{
  inputs,
  self,
  ...
}:
let
  toolchainFile = self.lib.fs.repoRoot + "/tools/configs/rust/rust-toolchain.toml";
in
{
  perSystem =
    { pkgs, ... }:
    let
      # Apply the rust overlay from `rust-overlay` input.
      pkgsRust = pkgs.extend (import inputs.rust-overlay);
    in
    {
      packages.rust-toolchain = pkgsRust.pkgsBuildHost.rust-bin.fromRustupToolchainFile toolchainFile;
    };
}
