{ ... }:
{
  # Define a `devenv` shell.
  # Pin the `pkgs` to the nixpkgsDevenv inputs to make it
  # more stable.
  mkShell =
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
