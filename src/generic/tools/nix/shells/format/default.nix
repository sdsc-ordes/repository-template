{
  pkgs,
  namespace,
  inputs,
  ...
}:
# Create the 'format' shell.
inputs.devenv.lib.mkShell {
  inherit inputs;
  pkgs = inputs.nixpkgsDevenv.legacyPackages.${pkgs.system};
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
