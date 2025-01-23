set positional-arguments
set shell := ["bash", "-cue"]
comp_dir := justfile_directory()
root_dir := `git rev-parse --show-toplevel`
flake_dir := "./tools/nix"

# Default target if you do not specify a target.
default:
    just --list

# Enter a Nix development shell.
develop *args:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"
    args=("$@") && [ "${#args[@]}" != 0 ] || args="$SHELL"
    nix develop --accept-flake-config "{{flake_dir}}#default" --command "${args[@]}"

# Format the whole repository.
format *args:
    nix run "{{flake_dir}}#treefmt" "$@"

# Setup the repository.
setup *args:
    cd "{{root_dir}}" && ./tools/ci/setup.sh
