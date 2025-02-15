{ pkgs, ... }:
{
  # Used to find the project root
  # We use `LICENSE` instead of `.git/config`
  # because that does not work with Git worktree.
  projectRootFile = "CONTRIBUTING.md";

  settings.global.excludes = [ "external/*" ];

  # Markdown, JSON, YAML, etc.
  programs.prettier.enable = true;

  # Python
  programs.ruff.enable = true;

  # Shell.
  programs.shfmt = {
    enable = true;
    indent_size = 4;
  };

  programs.shellcheck.enable = true;
  settings.formatter.shellcheck = {
    options = [
      "-e"
      "SC1091"
    ];
  };

  # Lua.
  programs.stylua.enable = true;

  # Nix.
  programs.nixfmt.enable = true;

  # Typos.
  programs.typos.enable = false;
}
