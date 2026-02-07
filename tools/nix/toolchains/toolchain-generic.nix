# This function returns a attrset of `devenv` modules
# which can be passed to `mkShell`.
{
  pkgs,
  ...
}:
{
  generic = [
    {
      packages = with pkgs; [
        skopeo
        yq
      ];

      languages.python = {
        enable = true;
        package = pkgs.python313;

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
    }
  ];
}
