{
  inputs,
  ...
}:
let
  config = {
    allowUnfree = true;
  };

  mkMultiverse =
    { system }:
    inputs.multiverse.lib.mkMultiverse {
      inherit system config;
      # No overlays for now needed.
    };
in
{
  flake.lib.nixpkgs = {
    # Shorthand to access the std library in the `nix repl`.
    lib = inputs.nixpkgs.lib;

    inherit mkMultiverse;

    importPkgs =
      {
        system,
      }:
      let
        mvs = mkMultiverse { inherit system; };
      in
      mvs.daysBehind "tip" 7; # Branch: 7 days behind nixos-unstable.

    importPkgsStable =
      {
        system,
      }:
      let
        mvs = mkMultiverse { inherit system; };
      in
      mvs.at "26.05"; # Branch: nixos-26.05
  };
}
