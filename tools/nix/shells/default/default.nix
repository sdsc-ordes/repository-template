{
  inputs,
  namespace,
  pkgs,
  ...
}@args:
let
  toolchains = import ../toolchain.nix { inherit pkgs namespace inputs; };

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
