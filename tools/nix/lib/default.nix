{ lib, ... }:
let
  fs = lib.fileset;
in
rec {
  rootDir = ../../..;
  rootFileset = fs.fromSource rootDir;

  # Define a `devenv` shell.
  # Pin the `pkgs` to the nixpkgsDevenv inputs.
  makeShell =
    {
      inputs,
      system,
      modules ? [ ],
    }:
    inputs.devenv.lib.mkShell {
      inherit inputs modules;
      pkgs = inputs.nixpkgsDevenv.legacyPackages.${system};
    };
}
