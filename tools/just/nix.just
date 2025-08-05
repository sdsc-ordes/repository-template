set positional-arguments
set shell := ["bash", "-cue"]

default:
    just --list --unsorted -f "{{source_file()}}"

# Enter the Nix development shell `$1` and execute the command `${@:2}`.
[no-cd]
develop *args:
    #!/usr/bin/env bash
    set -eu
    root_dir=$(git rev-parse --show-toplevel) || exit 1
    flake_dir="$root_dir/tools/nix"

    shell="$1"; shift 1;
    nix_args=()
    args=("$@") && [ "${#args[@]}" != 0 ] ||
        args=(env SHELL="$SHELL" "$SHELL")
    mkdir -p .devenv/state && pwd >.devenv/state/pwd

    # NOTE: Configurable flakes are not yet here:
    # This is for reading env. variable in the flake
    # to control behavior:
    # See configurable flakes: https://github.com/NixOS/nix/issues/5663
    if [ "${QUITSH_NIX_NO_PURE_EVAL:-}" = "true" ]; then
       nix_args+=("--no-pure-eval")
    fi

    nix develop \
        "${nix_args[@]}" \
        --accept-flake-config \
        --override-input devenv-root "path:.devenv/state/pwd" \
        "$flake_dir#$shell" \
        --command "${args[@]}"

# Start an Nix interpreter with loaded flake.
[no-cd]
repl:
    #!/usr/bin/env bash
    set -eu

    nix_args=()
    if [ "${QUITSH_NIX_NO_PURE_EVAL:-}" = "true" ]; then
       nix_args+=("--no-pure-eval")
    fi

    root_dir=$(git rev-parse --show-toplevel) || exit 1
    flake_dir="$root_dir/tools/nix"

    nix repl \
        "${nix_args[@]}" \
        --accept-flake-config \
        --override-input devenv-root "path:$root_dir/.devenv/state/pwd" \
        "$flake_dir"

# Build a package in the `packages` output of `flake.nix`
alias build := package
[no-cd]
package attrname *args:
    #!/usr/bin/env bash
    set -eu
    root_dir=$(git rev-parse --show-toplevel) || exit 1
    flake_dir="$root_dir/tools/nix"

    mkdir -p .output/package
    outlink=".output/package/{{attrname}}"
    nix build -L "$flake_dir#{{attrname}}" --out-link "$outlink" --json

# Show all packages.
[no-cd]
package-show:
    #!/usr/bin/env bash
    set -eu
    root_dir=$(git rev-parse --show-toplevel) || exit 1
    flake_dir="$root_dir/tools/nix"

    # We cannot use `nix flake show` due to other systems where
    # IFD (import-from-derivation -> from-yaml Nix derivation)
    # does not work.
    system=$(nix eval --impure --raw --expr builtins.currentSystem)
    nix eval --json "$flake_dir#packages.$system" | jq

# Fix all Nix hashes in repository.
[no-cd]
fix:
    just quitsh nix fix-hash
