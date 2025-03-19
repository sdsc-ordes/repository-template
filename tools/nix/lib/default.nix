{ lib, ... }:
let
  fs = lib.fileset;
in
rec {
  rootDir = ../../..;
  rootFileset = fs.fromSource rootDir;
}
