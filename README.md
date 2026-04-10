# tools-config

Per-host declarative config consumed by
[ivankovnatsky/tools](https://github.com/ivankovnatsky/tools). Each machine
file in `machines/` is the entry point, uses `include:` to pull in shared
configs.

## Repo setup

```console
# Create the GitHub repo
gh repo create ivankovnatsky/tools-config --public \
  --description "Per-host declarative config for tools"

# Clone via ghq
ghq get ivankovnatsky/tools-config

# Initialize main branch with empty signed commit
cd "$(ghq root)/github.com/ivankovnatsky/tools-config"
git checkout -b main
git commit --allow-empty -S -m "Initial commit"
git push -u origin main

# Set default branch to main
gh repo edit ivankovnatsky/tools-config --default-branch main
```

## Bootstrap

```console
# Install uv (Python package manager)
brew install uv

# Install tools CLI into an isolated venv
uv tool install git+https://github.com/ivankovnatsky/tools.git
```

This puts `tools` on PATH at `~/.local/bin/tools`.

## Usage

```console
# Apply config for this host
just apply

# Dry-run — show what would change
just diff

# Format all files
just format

# Lint without modifying
just lint
```
