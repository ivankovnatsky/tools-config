# Format all files
format:
    treefmt

# Lint without modifying
lint:
    prettier --check '**/*.yaml' '**/*.yml' '**/*.md'

# Apply config for this host
apply:
    tools --config .

# Dry-run — show what would change
diff:
    tools --config . --diff
