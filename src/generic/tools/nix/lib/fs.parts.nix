{
  lib,
  ...
}:
let
  repoRoot = ./../../..;
in
{
  # Lib filesystem.
  flake.lib.fs = {
    # The repository root directory (inside the Nix store).
    inherit repoRoot;

    # The repopsitory root fileset to be used with the
    # `lib.fileset` library.
    repoRootFileset = lib.fileset.fromSource repoRoot;
  };
}
