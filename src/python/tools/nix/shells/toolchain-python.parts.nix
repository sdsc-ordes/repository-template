{
  ...
}:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      toolchains.python = [
        {
          packages = [
            # Language Server.
            pkgs.pyright

            # Formatter and linter.
            pkgs.ruff

            pkgs.stdenv.cc.cc.lib # fix: libstdc++ required by jupyter.
            pkgs.libz # fix: for numpy/pandas import
          ];

          # We use `devenv` language support since, it's
          # pretty involved to setup a python environment.
          languages.python = {
            enable = true;

            # Heavy modules relying (CYTHON, ext. shared libraries etc)
            # should be built by Nix.
            package = pkgs.python313.withPackages (p: [
              p.numpy
              p.matplotlib
            ]);

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
    };
}
