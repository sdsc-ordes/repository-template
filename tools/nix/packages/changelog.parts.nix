{
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      # Generate a changelog.
      packages.generate-changelog = pkgs.writeShellApplication {
        name = "generate-changelog";
        runtimeInputs = [
          pkgs.git
          pkgs.gnugrep
          pkgs.coreutils
        ];

        text =
          # bash
          ''
            #!/usr/bin/env bash
            root_dir=$(git rev-parse --show-toplevel) || exit 1
            cd "$root_dir"

            tag="$1"
            config="$2"
            file="$3"

            lastTag=$(git describe --abbrev=0 --tags)
            if [ "$lastTag" = "" ]; then
                echo "No last tag found!" >&2
                echo "Create one!" >&2

                exit 1
            fi

            start=HEAD
            end="$lastTag"

            echo "Changelog in $end..$start" >&2

            if ! grep -q '<!-- next-content -->' "$file"; then
                echo "no '<!-- next-content -->' tag in '$file'"
                exit 1
            fi

            non_first_parent_commits=$(
                comm -23 <(git rev-list $end..$start | sort) \
                         <(git rev-list --ancestry-path --first-parent $end..$start |sort) | \
                xargs printf "%s "
            )

            out=$(git-cliff --config "$config" \
                "$end..$start" \
                --strip header \
                --skip-commit $non_first_parent_commits \
                --tag "$tag")

            echo "$out" | sed -i '/<!-- next-content -->/{
                r /dev/stdin
                d
            }' "$file"
          '';
      };
    };
}
