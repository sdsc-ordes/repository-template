{ inputs, lib, ... }:
{
  # Define a `devenv` shell.
  # Pin devenv's module function argument `pkgs` (if needed)
  # to `inputs.nixpkgs-devenv` inputs to make it
  # more stable.
  mkShell =
    {
      modules ? [ ],
      pkgs ? null,
      system ? null,
    }:
    assert lib.assertMsg (lib.hasAttr "self" inputs) "Inputs must contain `self`.";
    assert lib.assertMsg (lib.hasAttr "devenv" inputs) "Inputs must contain `devenv`.";
    assert lib.assertMsg (lib.hasAttr "nixpkgs-devenv" inputs) "Inputs must contain `nixpkgs-devenv`.";
    let
      pkgsForDevenv =
        if pkgs == null then
          assert lib.assertMsg (system != null) "System must be given";
          import inputs.nixpkgs-devenv {
            config.allowUnfree = true;
            inherit system;
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
      pkgs = pkgsForDevenv;

      modules = [
        (
          {
            devenv.flakesIntegration = true;
          }
          # Only apply it if `devenv-root` is defined.
          // lib.optionalAttrs (lib.hasAttr "devenv-root" inputs) {
            # This is currently needed for devenv to properly run in pure hermetic
            # mode while still being able to run processes & services and modify
            # (some parts) of the active shell.
            # We read here the root for devenv from the workaround flake input `devenv-root`.
            devenv.root = lib.strings.trim (builtins.readFile inputs.devenv-root.outPath);
          }
        )
      ]
      ++ modules;
    };
}
