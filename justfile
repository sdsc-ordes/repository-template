set positional-arguments
set shell := ["bash", "-cue"]
comp_dir := justfile_directory()
root_dir := `git rev-parse --show-toplevel`
flake_dir := "./tools/nix"

# Default target if you do not specify a target.
default:
    just --list

# Create a repository template.
create language destination:
    #!/usr/bin/env bash
    set -eu
    source ./tools/ci/general.sh
    [[ "{{language}}" =~ rust|go|python ]] ||
        ci::die "No such language '{{language}}'"

    cd "{{root_dir}}"
    just develop copier copy --trust "src/generic" "{{destination}}" \
        --data "project_language={{language}}"
    just develop copier copy --trust "src/{{language}}" "{{destination}}"

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
    cd "{{root_dir}}" && ./tools/scripts/setup.sh

# Test the coding scaffolding.
test: setup
    #!/usr/bin/env bash
    set -eu

    cd "{{root_dir}}" && rm -rf build

    uv run copier copy --trust -w  \
        --data "project_language=python" \
        --defaults  \
        src/generic \
        ./build

    uv run copier copy --trust -w \
        --defaults \
        src/python \
        ./build

    # Test the templated output.
    cd build &&
        git init && git add . && \
        git commit -a -m "init"

    just develop just setup

    cp tools/nix/flake.lock "{{root_dir}}/src/generic/tools/nix/flake.lock"

    just develop just format

    if ! git diff --exit-code --quiet . ; then
        echo "We have changes in the build folder."
    fi
