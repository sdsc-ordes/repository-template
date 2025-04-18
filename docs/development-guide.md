### Development Guide

This guide documents our procedures and policies for project maintenance tasks,
including managing our conventions, pull/merge-requests, continuous integration,
releasing.

## Commit Convention

We use the
[conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)
specification for commit messages and pull/merge-request titles.

### Scopes

Other scopes then the one in the specification are:

- `generic`: If the commit targets only the `generic` template.
- `python`: If the commit targets only the `python` template.
- `rust`: If the commit targets only the `rust` template.
- `go`: If the commit targets only the `go` template.

## Testing

Run

```shell
just test-all
```

To update the Nix Flakes, run
`REPOSITORY_TEMPLATE_UPDATE_FLAKES=true just test-all`.
