set positional-arguments
set shell := ["bash", "-cue"]
comp_dir := justfile_directory()
root_dir := `git rev-parse --show-toplevel`
output_dir := root_dir / ".output"
flake_dir := root_dir / "./tools/nix"

mod maintenance "./tools/just/mainentance.just"

# Default target if you do not specify a target.
default:
    just --list --unsorted

# Create a new project from a template.
create *args:
    just develop ./tools/scripts/create.sh "$@"

# Format the whole repository.
format *args:
    "{{root_dir}}/tools/scripts/setup-config-files.sh"
    nix run --accept-flake-config {{flake_dir}}#treefmt -- "$@"

# Setup the repository.
setup *args:
   just maintenance::setup "$@"

# Clean output folder.
clean:
    rm -rf ./.output

# Test a template.
test template="python":
   just maintenance::test "{{template}}"

# Test everything.
test-all:
   just maintenance::test-all

# Show all packages configured in the Nix `flake.nix`.
nix-list *args:
    cd tools/nix && nix flake --no-pure-eval show

# Enter the default Nix development shell.
develop *args:
    just nix-develop default "$@"

# Enter the Nix development shell `$1` and execute the command `${@:2}`.
[private]
nix-develop *args:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"
    shell="$1"; shift 1;
    args=("$@") && [ "${#args[@]}" != 0 ] || args="$SHELL"
    nix develop --no-pure-eval --accept-flake-config \
        "{{flake_dir}}#$shell" \
        --command "${args[@]}"
