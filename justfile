# Format all files
format:
    treefmt

# Lint: fail if formatting changes any file
lint:
    treefmt --fail-on-change

# Apply config for this host: user part, then system part as root
apply:
    sudo "$(command -v tools)" deploy --config .

# Apply only the user part (no daemons, /etc files, system defaults, settingsctl, users)
apply-user:
    tools deploy --config .

# Dry-run — show what would change
diff:
    tools diff --config .
