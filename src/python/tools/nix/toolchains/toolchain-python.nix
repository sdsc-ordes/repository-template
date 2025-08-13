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
      languages.python = {
        enable = true;
        package = pkgs.python313;

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
