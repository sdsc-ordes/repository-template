{
  self,
  inputs,
  lib,
  ...
}:
let
  repoRoot = ./../../..;

  # Lib filesystem.
  libFS = {
    # The repository root directory (inside the Nix store).
    repoRoot = "${repoRoot}";
  };

  # Lib import.
  libImport = import ./import.nix { inherit self inputs; };

  # Lib shell.
  libShell = import ./shell.nix { inherit inputs lib; };

  # Lib toolchains.
  libToolchain = import ./toolchains.nix { inherit repoRoot inputs lib; };
in
{
  flake.lib = {
    import = libImport;
    shell = libShell;
    fs = libFS;
    toolchain = libToolchain;
  };
}
