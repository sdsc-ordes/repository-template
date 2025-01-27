{
  lib,
  pkgs,
  namespace,
  ...
}@args:
let
  toolchains = import ../toolchain.nix args;

  githooks-install = pkgs.writeShellScript "githooks-install" (
    builtins.readFile ./entry-scripts/githooks-installed.sh
  );
in
# Create the 'default' shell.
pkgs.mkShell {
  packages = toolchains.default;

  shellHook = ''
    ${githooks-install}
    just setup
  '';
}
