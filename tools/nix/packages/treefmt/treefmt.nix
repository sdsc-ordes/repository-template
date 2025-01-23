{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = ".git/config";

  settings.global.excludes = [ "external/*" ];

  # Markdown, JSON, YAML, etc.
  programs.prettier.enable = true;

  programs.ruff.enable = true;

  programs.shfmt = {
    enable = true;
    indent_size = 4;
  };

  # Nix.
  programs.nixfmt.enable = true;
}
