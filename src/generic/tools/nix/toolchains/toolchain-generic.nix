# This function returns a attrset of `devenv` modules
# which can be passed to `mkShell`.
{
  self', # The own flake, where `system` is preselected.
  inputs', # All inputs where `system` is preselected.
  pkgs, # The unstable packages from the input `nixpkgs`.
  pkgsStable, # The stable packages from the inputs `nixpkgs-stable`.
  ...
}:
let
  # Fill in here devenv modules.
  # See attrset in `devenv.nix`: https://devenv.sh/basics/
  # See also the `toolchain-general.nix`.
  generic = [ ];
in
{
  inherit generic;
}
