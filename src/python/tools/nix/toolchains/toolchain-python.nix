# This function returns a attrset of `devenv` modules
# which can be passed to `mkShell`.
{
  self,
  lib,
  pkgs,
  ...
}:
{
  python = [
    {
      packages = [
        # Language Server.
        pkgs.pyright

        # Formatter and linter.
        pkgs.ruff

        pkgs.stdenv.cc.cc.lib # fix: libstdc++ required by jupyter.
        pkgs.libz # fix: for numpy/pandas import
      ];

      # We use `devenv` language support since, its
      # pretty involved to setup a python environment.
      # FIXME: Any `python313.withPackages` expression
      # cannot be used for creating a virtual environment (venv, uv etc.)
      # Until this is fixed: https://github.com/NixOS/nixpkgs/pull/442540).
      # See also https://github.com/astral-sh/uv/issues/16106
      languages.python = {
        enable = true;

        # Heavy modules relying (CYTHON, ext. shared libraries etc)
        # should be built by Nix.
        package = pkgs.python313.withPackages (p: [
          p.numpy
          p.matplotlib
        ]);

        directory = builtins.toString self.lib.fs.repoRoot;

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
  ];
}
