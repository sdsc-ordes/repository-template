#!/usr/bin/env bash
# shellcheck disable=SC1090

set -eu

ROOT_DIR=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
source "$ROOT_DIR/tools/ci/general.sh"

template=""
destination=""

while [[ $# -gt 0 ]]; do
    case $1 in
    -t | --template)
        template="$2"
        shift
        ;;
    -d | --destination)
        # Make absolute (resolve symlinks etc...)
        destination="$(realpath "$2")"
        shift
        ;;
    --help)
        ci::print_info "Usage: --template [generic|rust|go|python] --destination <path> [-- args-to-copier...]"
        exit 0
        ;;
    --)
        shift
        break
        ;;
    *) ci::die "Unknown arguments '$1'." ;;
    esac
    shift
done

args=("$@")

[[ $template =~ generic|rust|go|python ]] ||
    ci::die "No such template '$template' to template"

[[ -n $destination ]] || ci::die "Destination is empty."

mkdir -p "$destination"
cd "$ROOT_DIR"

just setup
source ./tools/scripts/activate-env.sh

ci::print_info "Rendering 'generic' template ... "
copier copy --trust "${args[@]}" \
    --data "project_language=$template" \
    "src/generic" "$destination" ||
    ci::die "Could not apply template '$template'."
ci::print_info "Rendering 'generic' template completed."

if [ "$template" != "generic" ]; then
    answer_file="$destination/tools/configs/copier/answers/generic.yaml"

    ci::print_info "Rendering '$template' template ..."
    copier copy --trust "${args[@]}" \
        --data "project_authors=$(yq -r ".project_authors" "$answer_file")" \
        --data "project_hosts=$(yq -r ".project_hosts" "$answer_file")" \
        --data "project_version=$(yq -r ".project_version" "$answer_file")" \
        --data "project_description=$(yq -r ".project_description" "$answer_file")" \
        --data "project_url=$(yq -r ".project_url" "$answer_file")" \
        "src/$template" "$destination" ||
        ci::die "Could not apply template '$template'."
    ci::print_info "Rendering '$template' template completed."
fi

if ! git -C "$destination" rev-parse --show-toplevel &>/dev/null; then
    # If we are not inside a Git repo we need to init.
    ci::print_info "Initializing Git repo '$destination'"
    git -C "$destination" init || ci::die "Could not initialize Git repo."
fi

if [ "$(git -C "$destination" rev-parse --show-toplevel 2>/dev/null)" == "$destination" ]; then
    # If we are inside the top level, add the files directly.
    ci::print_info "Staging all files."
    git -C "$destination" add . || ci::die "Could not stage all files."
fi
