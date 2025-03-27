{
  pkgs,
  namespace,
  inputs,
  ...
}:
inputs.devenv.lib.mkShell {
  inherit inputs;
  pkgs = inputs.nixpkgsDevenv.legacyPackages.${pkgs.system};
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
