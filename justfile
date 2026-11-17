# Format all files
format:
    treefmt

# Lint: fail if formatting changes any file
lint:
    treefmt --fail-on-change

# Apply config for this host
apply:
    tools deploy --config .

# Dry-run — show what would change
diff:
    tools diff --config .
