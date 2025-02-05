set positional-arguments
set shell := ["bash", "-cue"]
comp_dir := justfile_directory()
root_dir := `git rev-parse --show-toplevel`
output_dir := root_dir / ".output"
flake_dir := "./tools/nix"

# Default target if you do not specify a target.
default:
    just --list

# Create a repository template.
create *args:
    just develop just create-impl "$@"

[private]
create-impl *args:
    #!/usr/bin/env bash
    set -eu
    source ./tools/ci/general.sh

    template="$1"
    destination="$(mkdir -p "$2" && cd "$2" && pwd)" # Make absolute.
    args=("${@:3}")

    [[ "$template" =~ generic|rust|go|python ]] ||
        ci::die "No such template '$template' to template"
    cd "{{root_dir}}"

    copier copy --trust "${args[@]}" \
        "src/generic" "$destination" \
        --data "project_language=$template" ||
        ci::die "Could not apply template '$template'."

    if [ "$template" != "generic" ]; then
        answer_file="$destination/tools/configs/copier/answers/generic.yaml"

        copier copy --trust "${args[@]}" \
            "src/$template" "$destination" \
            --data "project_authors=$(yq -r ".project_authors" "$answer_file")" \
            --data "project_hosts=$(yq -r ".project_hosts" "$answer_file")" \
            --data "project_version=$(yq -r ".project_version" "$answer_file")" \
            --data "project_description=$(yq -r ".project_description" "$answer_file")" \
            --data "project_url=$(yq -r ".project_url" "$answer_file")" ||
            ci::die "Could not apply template '$template'."
    fi

    if ! git -C "$destination" rev-parse --show-toplevel &>/dev/null; then
        # If we are not inside a Git repo we need to
        git -C  "$destination" init || ci::die "Could not initialize Git repo."
    fi

    if [ "$(git -C "$destination" rev-parse --show-toplevel 2>/dev/null)" == "$destination" ]; then
        # If we are inside the top level, add the files directly.
        git -C "$destination" add . || ci::die "Could not stage all files."
    fi


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
test template="python": setup
    #!/usr/bin/env bash
    set -eu
    source "{{root_dir}}/tools/ci/general.sh"

    ci::print_info "Running test '{{template}}'"
    ci::print_info "======================"
    build_dir="{{output_dir}}/{{template}}"
    cd "{{root_dir}}" && rm -rf "$build_dir"

    uv run copier copy --trust -w  \
        --data "project_language={{template}}" \
        --defaults  \
        src/generic \
        "$build_dir"

    if [ "{{template}}" != "generic" ]; then
        answer_file="$build_dir/tools/configs/copier/answers/generic.yaml"
        uv run copier copy --trust -w \
            --data "project_authors=$(yq -r ".project_authors" "$answer_file")" \
            --data "project_hosts=$(yq -r ".project_hosts" "$answer_file")" \
            --data "project_version=$(yq -r ".project_version" "$answer_file")" \
            --data "project_description=$(yq -r ".project_description" "$answer_file")" \
            --data "project_url=$(yq -r ".project_url" "$answer_file")" \
            --defaults \
            "src/{{template}}" \
            "$build_dir"
    fi

    # Test the templated output.
    cd "${build_dir}" &&
        git init && git add . && \
        git commit -a -m "init"

    just develop just setup
    just develop just format
    just develop just lint
    just develop just build
    just develop just run

    cp tools/nix/flake.lock "{{root_dir}}/src/{{template}}/tools/nix/flake.lock"
    if [ "{{template}}" == "python" ]; then
        cp uv.lock "{{root_dir}}/src/{{template}}/uv.lock"
    elif [ "{{template}}" == "go" ]; then
        cp go.work.sum "{{root_dir}}/src/{{template}}/go.work.sum"
        cp src/tool/go.sum "{{root_dir}}/src/{{template}}/src/{{{{ package_name }}/go.sum"
    elif [ "{{template}}" == "rust" ]; then
        cp Cargo.lock "{{root_dir}}/src/{{template}}/Cargo.lock"
    fi

    git clean -df

    if ! git diff --exit-code --quiet . ; then
        echo "We have changes in the build folder."
    fi
