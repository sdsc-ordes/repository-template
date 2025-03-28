{
  lib,
  ...
}:
with lib;
let
  # List all toolchain files in `dir` (returns `{ "toolchain-go.nix" = "regular", ...  }`  )
  toolchain-files =
    dir:
    attrsets.filterAttrs (
      k: v: strings.hasPrefix "toolchain-" k && strings.hasSuffix ".nix" k && v == "regular"
    ) (builtins.readDir dir);

  # Modifies into `{ "go" = {"path" = ...; }, ... }`
  toolchains =
    dir:
    attrsets.concatMapAttrs (
      k: v:
      let
        language = strings.removeSuffix ".nix" (strings.removePrefix "toolchain-" k);
      in
      {
        ${language} = {
          path = dir + "/${k}";
        };
      }
    ) (toolchain-files dir);

  # Import all toolchains.
  import-all =
    dir: args:
    attrsets.concatMapAttrs (lang: file: {
      ${lang} = (import file.path) args;
    }) (toolchains dir);
in
{
  # Imports all files `toolchain-<language>.nix` which define a list of language specific
  # packages, returns `{ "go" = [...];, "python" = [...]; }`.
  import = dir: args: import-all dir args;
}
