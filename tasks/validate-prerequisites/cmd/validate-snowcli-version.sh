#!/usr/bin/env bash

# Validate Snowflake CLI is installed and meets the minimum version requirement.
# Usage: ./validate-snowcli-version.sh <minimum_version>
# Example: ./validate-snowcli-version.sh 3.16.0

MIN_VERSION="${1:?Usage: $0 <minimum_version>}"

if ! command -v snow >/dev/null 2>&1; then
  echo "ERROR: Snowflake CLI (snow) is not installed."
  echo "Follow the instructions at https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation to install it."
  exit 1
fi

INSTALLED_VERSION=$(snow --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [ -z "$INSTALLED_VERSION" ]; then
  echo "ERROR: Could not determine Snowflake CLI version."
  exit 1
fi

# Compare versions using sort -V (version sort)
LOWEST=$(printf '%s\n%s\n' "$MIN_VERSION" "$INSTALLED_VERSION" | sort -V | head -1)

if [ "$LOWEST" = "$MIN_VERSION" ]; then
  echo "Snowflake CLI version $INSTALLED_VERSION meets minimum requirement ($MIN_VERSION)."
else
  echo "ERROR: Snowflake CLI version $INSTALLED_VERSION is below the minimum required version $MIN_VERSION."
  echo "Follow the instructions at https://docs.snowflake.com/en/developer-guide/snowflake-cli/installation/installation to upgrade to the latest version."
  exit 1
fi
