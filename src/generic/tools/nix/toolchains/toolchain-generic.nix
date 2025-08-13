# This function returns a attrset of `devenv` modules
# which can be passed to `mkShell`.
{
  self',
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
