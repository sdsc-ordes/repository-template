#!/usr/bin/env bash
# shellcheck disable=SC1090

set -eu

ROOT_DIR=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
source "$ROOT_DIR/tools/ci/general.sh"

TEMPLATE=""
DESTINATION=""
ARGS=()

function die_help() {
    help
    ci::die "$@"
}

function help() {
    ci::print_info "Usage: --template [generic|rust|go|python] --destination <path> [-- args-to-copier...]"
}

function parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
        -t | --template)
            TEMPLATE="$2"
            shift
            ;;
        -d | --destination)
            # Make absolute (resolve symlinks etc...)
            DESTINATION="$(realpath "$2")"
            shift
            ;;
        --help)
            help
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

    ARGS=("$@")
}

parse_args "$@"

[[ $TEMPLATE =~ generic|rust|go|python ]] ||
    die_help "No such template '$TEMPLATE' to template"
[[ -n $DESTINATION ]] ||
    die_help "Destination is empty."

mkdir -p "$DESTINATION"
cd "$ROOT_DIR"

just setup

ci::print_info "Rendering 'generic' template ... "
copier copy --trust "${ARGS[@]}" \
    --data "project_language=$TEMPLATE" \
    "src/generic" "$DESTINATION" ||
    ci::die "Could not apply template '$TEMPLATE'."
ci::print_info "Rendering 'generic' template completed."

if [ "$TEMPLATE" != "generic" ]; then
    answer_file="$DESTINATION/tools/configs/copier/answers/generic.yaml"

    ci::print_info "Rendering '$TEMPLATE' template ..."
    copier copy --trust "${ARGS[@]}" \
        --data "project_authors=$(yq -r ".project_authors" "$answer_file")" \
        --data "project_hosts=$(yq -r ".project_hosts" "$answer_file")" \
        --data "project_version=$(yq -r ".project_version" "$answer_file")" \
        --data "project_description=$(yq -r ".project_description" "$answer_file")" \
        --data "project_url=$(yq -r ".project_url" "$answer_file")" \
        "src/$TEMPLATE" "$DESTINATION" ||
        ci::die "Could not apply template '$TEMPLATE'."
    ci::print_info "Rendering '$TEMPLATE' template completed."
fi

if ! git -C "$DESTINATION" rev-parse --show-toplevel &>/dev/null; then
    # If we are not inside a Git repo we need to init.
    ci::print_info "Initializing Git repo '$DESTINATION'"
    git -C "$DESTINATION" init || ci::die "Could not initialize Git repo."
fi

if [ "$(git -C "$DESTINATION" rev-parse --show-toplevel 2>/dev/null)" == "$DESTINATION" ]; then
    # If we are inside the top level, add the files directly.
    ci::print_info "Staging all files."
    git -C "$DESTINATION" add . || ci::die "Could not stage all files."
fi
