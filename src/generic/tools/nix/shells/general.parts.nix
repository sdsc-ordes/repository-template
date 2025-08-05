{
  self,
  ...
}:
{
  perSystem =
    {
      self,
      inputs,
      self',
      inputs',
      pkgs,
      pkgsStable,
      ...
    }@args:
    let
      toolchains = self.lib.toolchain.import args;
    in
    {
      devShells.format = self.lib.shell.mkShell {
        inherit (args) system;
        modules = toolchains.format;
      };

      # The CI shell is the same as the default.
      devShells.ci = self'.devShells.default;
    };
}
