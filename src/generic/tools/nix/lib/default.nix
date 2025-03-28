{
  lib,
  ...
}:
let
  repo-root = ./../../..;
in
{
  # Filesystem functionality.
  fs = {
    # The repository root directory (inside the Nix store).
    root-dir = "${repo-root}";
  };

  # Toolchain functionality.
  toolchain = import ./toolchain-files.nix { inherit lib; };

  # Shell functionality.
  shell = import ./shell.nix { inherit lib; };
}
