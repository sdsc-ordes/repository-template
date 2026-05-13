{
  inputs,
  self,
  ...
}:
let
  # This should be used in a devShell.
  toolchainFile = self.lib.fs.repoRoot + "/tools/configs/rust/rust-toolchain.toml";

  # This should be used for building a rust Nix derivation.
  toolchainFileRelease = self.lib.fs.repoRoot + "/tools/configs/rust/rust-toolchain-release.toml";
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
      packages.rust-toolchain-release = pkgsRust.pkgsBuildHost.rust-bin.fromRustupToolchainFile toolchainFileRelease;
    };
}
