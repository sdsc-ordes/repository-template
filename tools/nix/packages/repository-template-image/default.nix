{
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}:
let
  fs = lib.fileset;
  llib = lib.${namespace};
  version = "latest";

  # This is the Nix base image.
  nixBase = import (inputs.nix.outPath + "/docker.nix") {
    pkgs = pkgs;
    name = "local/nix-base";
    tag = "latest";

    uid = 1000;
    gid = 1000;
    uname = "non-root";
    gname = "non-root";

    bundleNixpkgs = false;
    maxLayers = 2;

    nixConf = {
      cores = "0";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  repository = fs.toSource {
    root = llib.rootDir;
    fileset = llib.rootFileset;
  };

  repositoryTemplate = (
    pkgs.dockerTools.buildImage {
      name = "ghcr.io/sdsc-ordes/repository-template/create";
      tag = version;

      # uid = 1000;
      # gid = 1000;
      # uname = "non-root";
      # gname = "non-root";

      copyToRoot = pkgs.buildEnv {
        name = "root";
        pathsToLink = [ "/bin" ];
        paths = [
          pkgs.${namespace}.bootstrap

          pkgs.bash

          pkgs.uv
          pkgs.python313
          pkgs.yq
        ];
      };

      runAsRoot = ''
        # ${pkgs.dockerTools.shadowSetup}
        # groupadd -r -g 1000 non-root
        # useradd -r -g 1000 -u 1000 -m --home-dir /home/non-root non-root

        # Place  /usr/bin/env
        mkdir -p /usr/bin
        ln -s ${pkgs.coreutils}/bin/env /usr/bin/env

        usrDir="/root"
        dir="$usrDir/repo"

        mkdir -p "$dir"
        cp -rf "${repository}/." "$dir/"
        # chown -R non-root:non-root "$dir"
        chmod -R +w "$dir"

        cd "$dir"
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
repositoryTemplate
