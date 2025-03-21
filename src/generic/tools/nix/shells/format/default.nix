{
  pkgs,
  namespace,
  inputs,
  ...
}:
# Create the 'format' shell.
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = [
    (
      { pkgs, ... }:
      {
        packages = [
          pkgs.${namespace}.treefmt
        ];
      }
    )
  ];
}
