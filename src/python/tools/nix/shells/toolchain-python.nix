# This function returns a list of `devenv` modules
# which are passed to `mkShell`.
#
# Search for package at:
# https://search.nixos.org/packages
{
  # These are `pkgs` from `input.nixpkgs`.
  pkgs,
  lib,
  namespace,
  ...
}:
[
  {
    packages = [
      pkgs.${namespace}.bootstrap
      pkgs.${namespace}.treefmt

      # Language Server.
      pkgs.pyright

      # Formatter and linter.
      pkgs.ruff

      pkgs.stdenv.cc.cc.lib # fix: libstdc++ required by jupyter.
      pkgs.libz # fix: for numpy/pandas import
    ];

    # We use `devenv` language support since, its
    # pretty involved to setup a python environment.
    languages.python = {
      directory = lib.${namespace}.fs.root-dir;
      enable = true;
      venv.enable = true;
      uv = {
        enable = true;
        package = pkgs.uv;
        sync = {
          enable = true;
          allExtras = true;
        };
      };
    };

    env = {
      RUFF_CACHE_DIR = ".output/cache/ruff";
    };

    enterShell = ''
      just setup
    '';

    env.LD_LIBRARY_PATH = "${lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.libz
    ]}";
  }
]
