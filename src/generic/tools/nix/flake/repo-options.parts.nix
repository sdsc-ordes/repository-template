# Module for flake-parts which
# defines repospecific module options which can be set
# in other flake-parts modules.
{
  lib,
  flake-parts-lib,
  ...
}:
let
  inherit (flake-parts-lib) mkPerSystemOption;

  mkLibOption =
    desc:
    lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      description = desc;
      default = { };
    };

  libDefs = {
    fs = mkLibOption "Filesystem functions.";
    shell = mkLibOption "Shell helper functions.";
    nixpkgs = mkLibOption "Nixpkgs import utility.";
  };
in
{
  options = {
    # Define `lib` as flake output which is our
    # own standalone reusable library which is not
    # repository/system/pkgs dependent.
    flake.lib = libDefs;
  };

  # Creates a `perSystem.toolchains.<key> = [ <devenvModule> ]` option.
  options.perSystem = mkPerSystemOption (
    {
      lib,
      ...
    }:
    {
      options.toolchains = lib.mkOption {
        description = "Attrset of toolchain definitions keyed by toolchain name, where each value is a list of devenv modules.";
        default = { };
        type = lib.types.attrsOf (lib.types.listOf lib.types.deferredModule);
      };
    }
  );
}
