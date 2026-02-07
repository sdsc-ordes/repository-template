{
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { self', pkgs, ... }:
    let
      fs = lib.fileset;
      llib = inputs.self.lib;

      version = "latest";

      repository = fs.toSource {
        root = llib.fs.repoRoot;
        fileset = llib.fs.repoRootFileset;
      };

      image = (
        pkgs.dockerTools.buildImage {
          name = "ghcr.io/sdsc-ordes/repository-template";
          tag = version;

          copyToRoot = pkgs.buildEnv {
            name = "root";
            pathsToLink = [ "/bin" ];
            paths = [
              self'.packages.bootstrap

              pkgs.bash

              pkgs.uv
              pkgs.python313
              pkgs.yq
            ];
          };

          # WARNING: This runs ins VM!
          runAsRoot = ''
            # Place  /usr/bin/env
            mkdir -p /usr/bin
            ln -s ${pkgs.coreutils}/bin/env /usr/bin/env

            usrDir="/root"
            dir="$usrDir/repo"

            mkdir -p "$dir"
            cp -rf "${repository}/." "$dir/"
            chmod -R +w "$dir"

            cd "$dir"
            export HOME=/root
            "${pkgs.git}/bin/git" config -f "$usrDir/.gitconfig" \
              --add safe.directory '*'
            "${pkgs.git}/bin/git" config -f "$usrDir/.gitconfig" \
              init.defaultBranch main

            "${pkgs.git}/bin/git" init
            "${pkgs.git}/bin/git" add .

            mkdir -p /workspace
          '';

          config = {
            Entrypoint = [
              "/root/repo/tools/scripts/create.sh"
            ];

            Env = [
              "USER=root"
              "HOME=/root"
              "REPO_TEMPLATE_IN_CONTAINER=true"
            ];

            WorkingDir = "/workspace";

            Volumes = {
              "/workspace" = { };
            };

            Labels = {
              "org.opencontainers.image.source" = "https://github.com/sdsc-ordes/repository-template";
              "org.opencontainers.image.description" = "Deploy image for creating repository templates.";
              "org.opencontainers.image.license" = lib.licenses.asl20.fullName;
              "org.opencontainers.image.version" = version;
            };
          };
        }
      );
    in
    {
      packages.repository-template-image = image;
    };
}
