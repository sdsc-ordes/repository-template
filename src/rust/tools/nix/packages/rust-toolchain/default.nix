{
  pkgs,
  lib,
  namespace,
  ...
}:
let
  toolchainFile = lib.${namespace}.fs.root-dir + "/tools/configs/rust/rust-toolchain.toml";
in
pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile toolchainFile
