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

        uv
        python313
        yq
      ];

      env = {
        RUFF_CACHE_DIR = ".output/cache/ruff";
      };

      enterShell = ''
        just setup
        source ./tools/scripts/activate-env.sh
      '';
    }
  ];
}
