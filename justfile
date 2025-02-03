set positional-arguments
set shell := ["bash", "-cue"]
comp_dir := justfile_directory()
root_dir := `git rev-parse --show-toplevel`
flake_dir := "./tools/nix"

# Default target if you do not specify a target.
default:
    just --list

# Create a repository template.
create *args:
    #!/usr/bin/env bash
    set -eu
    source ./tools/ci/general.sh

    language="$1"
    destination="$2"
    args=("${@:3}")

    [[ "$language" =~ generic|rust|go|python ]] ||
        ci::die "No such language '$language'"

    cd "{{root_dir}}"

    just develop copier copy --trust "${args[@]}" \
        "src/generic" "$destination" \
        --data "project_language=$language"

    if [ "$language" == "generic" ]; then
        exit 0
    fi

    just develop copier copy --trust "${args[@]}" \
        "src/$language" "$destination" \
        --data "module_version=$(yq -r ".project_version" "$destination/tools/copier/answers/.generic.yaml")" \

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

# Test all templates.
test-all:
    just test generic
    just test python
    just test rust

# Test the coding scaffolding.
test lang="python": setup
    #!/usr/bin/env bash
    set -eu
    source "{{root_dir}}/tools/ci/general.sh"

    ci::print_info "Running test '{{lang}}'"
    ci::print_info "======================"
    build_dir="build/{{lang}}"
    cd "{{root_dir}}" && rm -rf "${build_dir}"

    uv run copier copy --trust -w  \
        --data "project_language={{lang}}" \
        --defaults  \
        src/generic \
        "${build_dir}"

    if [ "{{lang}}" != "generic" ]; then
        uv run copier copy --trust -w \
            --data "module_version=$(yq -r ".project_version" ./build/tools/copier/answers/.generic.yaml)" \
            --defaults \
            "src/{{lang}}" \
            "${build_dir}"
    fi

    # Test the templated output.
    cd "${build_dir}" &&
        git init && git add . && \
        git commit -a -m "init"

    just develop just setup
    just develop just lint
    just develop just build
    just develop just run

    cp tools/nix/flake.lock "{{root_dir}}/src/{{lang}}/tools/nix/flake.lock"

    just develop just format

    if ! git diff --exit-code --quiet . ; then
        echo "We have changes in the build folder."
    fi
