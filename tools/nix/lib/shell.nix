{ inputs, ... }:
{
  # Define a `devenv` shell.
  # Pin devenv's module function argument `pkgs` (if needed)
  # to `inputs.nixpkgs-devenv` inputs to make it
  # more stable.
  mkShell =
    {
      system,
      pkgs ? null,
      modules ? [ ],
    }:
    let
      # Devenv was tested against its own `nixpkgs-devenv` version.
      # We use that as `pkgs` in the devenv modules.
      # One can still use the flake-parts `pkgs` which is from `inputs.nixpkgs`
      # to be more up-to-date.
      devenvPkgs =
        if pkgs == null then
          import inputs.nixpkgs-devenv {
            inherit system;
            config.allowUnfree = true;
          }
        else
          pkgs;

      # Only inject what devenv really uses;
      ins = {
        inherit (inputs) self devenv;

        # Why nixpkgs is used is a bit weird.
        # See https://github.com/cachix/devenv/pull/2091
        nixpkgs = inputs.nixpkgs-devenv;
      };
    in
    inputs.devenv.lib.mkShell {
      inputs = ins;
      pkgs = devenvPkgs;

      modules = [
        {
          devenv.flakesIntegration = true;
        }
      ]
      ++ modules;
    };
}
