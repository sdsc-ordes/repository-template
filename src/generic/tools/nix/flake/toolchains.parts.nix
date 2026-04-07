{
  flake-parts-lib,
  ...
}:
let
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  # Creates a `perSystem.toolchains.<key> = [ <devenvModule> ]` option.
  options.perSystem = mkPerSystemOption (
    {
      lib,
      ...
    }:
    {
      options.toolchains = lib.mkOption {
        description = "List of devenv modules.";
        type = lib.types.attrsOf (lib.types.listOf lib.types.deferredModule);
      };
    }
  );
}
