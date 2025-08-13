# This function returns a attrset of `devenv` modules
# which can be passed to `mkShell`.
{
  self',
  ...
}:
let
  format = [
    {
      packages = [
        self'.packages.treefmt
      ];
    }
  ];

  general = format ++ [
    {
      packages = [
        self'.packages.bootstrap
      ];
    }
  ];

in
{
  inherit format general;
}
