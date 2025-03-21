{
  pkgs,
  namespace,
  inputs,
  ...
}:
inputs.devenv.lib.mkShell {
  inherit pkgs inputs;
  modules = [
    (
      { ... }:
      {
        packages = [
          pkgs.${namespace}.treefmt
        ];
      }
    )
  ];
}
