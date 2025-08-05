{ inputs, ... }:
{
  # Define a `devenv` shell.
  # Pin devenv's module function argument `pkgs` (if needed)
  # to `inputs.nixpkgs-devenv` inputs to make it
  # more stable.
  mkShell =
    {
      system,
      modules ? [ ],
    }:
    let
      pkgs = inputs.nixpkgs-devenv.legacyPackages.${system};
    in
    inputs.devenv.lib.mkShell {
      inherit inputs pkgs;

      modules = [
        {
          devenv.flakesIntegration = true;
        }
      ] ++ modules;
    };
}
