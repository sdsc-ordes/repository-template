# Nix tricks: the module system uses
# `builtins.functionArgs` to determine what to pass in `perSystem`.
# We only need to destructure the arguments not passed by default (`self'`, etc.)
{
  self,
  ...
}:
{
  perSystem =
    {
      config,
      self',
      ...
    }:
    let
      args = config.allModuleArgs;
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
