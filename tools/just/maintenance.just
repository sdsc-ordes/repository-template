set positional-arguments
set shell := ["bash", "-cue"]
root_dir := `git rev-parse --show-toplevel`
output_dir := root_dir / ".output"
flake_dir := root_dir / "./tools/nix"
container_mgr := "podman"

default:
    just --list --unsorted -f "{{source_file()}}"

# Setup the repository.
setup *args:
    "{{root_dir}}/tools/scripts/setup.sh"

# Build the deploy image for the users to create a repo-template.
build-deploy-image:
    nix build -L \
    --no-pure-eval --accept-flake-config \
    "{{root_dir}}/tools/nix#repository-template-image" --out-link \
        "{{output_dir}}/image/repository-template-latest"


# Build the deploy image for the users to create a repo-template.
load-deploy-image: build-deploy-image
    cd "{{root_dir}}" && \
    "{{container_mgr}}" load < .output/image/repository-template-latest

# Push the image to the registry.
push-deploy-image: build-deploy-image
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}" && \
    skopeo login ghcr.io/sdsc-ordes && \
    skopeo copy \
        "docker-archive:.output/image/repository-template-latest" \
        "docker://ghcr.io/sdsc-ordes/repository-template:latest"

# Test all templates.
test-all:
    just maintenance::test generic
    just maintenance::test python
    just maintenance::test rust
    just maintenance::test go
    just maintenance::test-image

# Test the code scaffolding.
test template="python": ci-setup setup
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

    if [ "${REPOSITORY_TEMPLATE_UPDATE_FLAKES:-}" = "true" ]; then
        ci::print_warn \
        "===========================" \
        "Updating flakes in template." \
        "==========================="
        (cd tools/nix && nix flake update)
    fi

    just develop just setup
    just develop just format
    just develop just lint
    just develop just build
    just develop just run

    ci::print_info "Coping back lock files..."
    cp -v tools/nix/flake.lock "{{root_dir}}/src/{{template}}/tools/nix/flake.lock"
    if [ "{{template}}" == "python" ]; then
        cp -v uv.lock "{{root_dir}}/src/{{template}}/uv.lock"
    elif [ "{{template}}" == "go" ]; then
        cp -v go.work.sum "{{root_dir}}/src/{{template}}/go.work.sum"
        cp -v src/tool/go.sum "{{root_dir}}/src/{{template}}/src/{{{{ package_name }}/go.sum"
    elif [ "{{template}}" == "rust" ]; then
        cp -v Cargo.lock "{{root_dir}}/src/{{template}}/Cargo.lock"
    fi

    git clean -df

    if ! git diff --exit-code --quiet . ; then
        echo "We have changes in the build folder."
    fi

# Create and upload the code scaffolding.
upload-all:
    just maintenance::upload generic
    just maintenance::upload rust
    just maintenance::upload go
    just maintenance::upload python

    just maintenance::push-deploy-image

# Create and upload the code scaffolding.
upload template="python": ci-setup setup
    #!/usr/bin/env bash
    set -eu
    source "{{root_dir}}/tools/ci/general.sh"

    temp_dir=$(mktemp -d)
    function cleanup() {
        [ ! -d "$temp_dir" ] || {
            ci::print_info "removing temp dir"
            # rm -rf "$temp_dir"
        }
    }
    trap cleanup EXIT

    build_dir="$temp_dir/{{template}}"
    ci::print_info "======================"
    ci::print_info "Upload '{{template}}' '$build_dir'"

    cd "{{root_dir}}" && rm -rf "$build_dir" && mkdir -p "$build_dir"
    just create -t "{{template}}" -d "$build_dir" -- -l -f

    cd "$build_dir"

    # Add WARNING
    cat <(
        echo "> [!WARNING]"
        echo ">"
        echo "> This is a demo rendering of the [\`{{template}}\` template here](https://github.com/sdsc-ordes/repository-template#{{template}}-template)"
        echo
        cat README.md
    ) > README.md.mod  && mv README.md.mod README.md

    export GITHOOKS_DISABLE=true
    git init &&
      just develop just format &&
      git add . &&
      git commit -a -m "init"

    git remote add origin \
        "https://github.com/sdsc-ordes/repository-template-{{template}}.git"

    branch="main"
    if ! ci::is_running; then
        branch="test"
        git switch -c "$branch"
    fi

    git checkout "$branch"
    git push origin --force

test-image:
    cd "{{root_dir}}"
    just maintenance::build-deploy-image
    just maintenance::load-deploy-image

    mkdir -p "{{output_dir}}/image"
    "{{container_mgr}}" run -it -v "{{output_dir}}/image:/workspace" \
            ghcr.io/sdsc-ordes/repository-template:latest \
            -t python -d "./test" -- -w -l

[private]
ci-setup:
    #!/usr/bin/env bash
    [ "${CI:-}" == true ] || exit 0
    git config --global user.name "CI"
    git config --global user.email "ci@noreply.github.com"
