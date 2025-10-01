{
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      # Generate a changelog from `HEAD` to the last tag on the current branch.
      # With the following arguments.
      # `$1: The new tag.`
      # `$2: End Git reference (default: last tag)`
      # `$3: Start Git reference (default: `HEAD`)`
      # `$4: Config file for `git-cliff` (optional)
      # `$5`: Changelog file to update (default: `CHANGELOG.md`)
      # NOTE: Due to Nix you need to escape with `''${VAR}`
      packages.generate-changelog = pkgs.writeShellApplication {
        name = "generate-changelog";
        runtimeInputs = [
          pkgs.git
          pkgs.gnugrep
          pkgs.coreutils
          pkgs.git-cliff
        ];

        text =
          # bash
          ''
            #!/usr/bin/env bash
            set -eu

            root_dir=$(git rev-parse --show-toplevel) || exit 1
            cd "$root_dir"

            tag="$1"
            end="''${2:-}"
            start="''${3:-}"
            config="''${4:-tools/config/git-cliff/config.toml}"
            file="''${5:-CHANGELOG.md}"

            export GIT_CLIFF_TAG_PATTERN="''${GIT_CLIFF_TAG_PATTERN:-v\d+}"

            if [ -z "$end" ]; then
                end=$(git describe --abbrev=0 --tags)
                if [ "$end" = "" ]; then
                    echo "No last tag found!" >&2
                    echo "Create one!" >&2

                    exit 1
                fi
            fi


            echo "Changelog in '$end..$start'" >&2

            if ! grep -q '<!-- next-content -->' "$file"; then
                echo "no '<!-- next-content -->' tag in '$file'"
                exit 1
            fi

            non_first_parent_commits=()
            readarray -t non_first_parent_commits < <(
                comm -23 <(git rev-list "$end..$start" | sort) \
                         <(git rev-list --ancestry-path --first-parent "$end..$start" |sort)
            )

            skip_args=()
            if [ "''${#non_first_parent_commits[@]}" -ne 0 ]; then
              # shellcheck disable=SC2086,SC2206
              skip_args=(--skip-commit)
              skip_args+=("''${non_first_parent_commits[@]}")
            fi

            out=$(git-cliff --config "$config" \
                "$end..$start" \
                --strip header \
                "''${skip_args[@]}" \
                --tag "$tag")

            # Replace in file.
            if [ -n "$file" ]; then
              echo "$out" | sed -i '/<!-- next-content -->/{
                  r /dev/stdin
                  d
              }' "$file"
            else
              echo "$out"
            fi
          '';
      };
    };
}
