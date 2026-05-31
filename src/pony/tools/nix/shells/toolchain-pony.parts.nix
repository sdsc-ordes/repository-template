{
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      toolchains.pony = [
        (
          { config, ... }:
          {
            packages = [
              pkgs.pony-corral
              pkgs.ponyc
            ];

            env = {
              CORRAL_HOME = "${config.devenv.state}/pony/corral";
            };
          }
        )
      ];
    };
}
