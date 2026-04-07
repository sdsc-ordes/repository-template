{
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      # The shell modules (devenv) for a generic shell.
      toolchains.generic = [
        {
          packages = [ pkgs.cowsay ];
        }
      ];
    };
}
