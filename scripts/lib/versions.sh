#!/usr/bin/env bash
# Note: this file should be sourced by bash. If sourced via /bin/sh, some features may not work.
if [ -z "${BASH_VERSION:-}" ]; then
  >&2 echo "This script requires bash. Re-run with: bash -c 'source scripts/lib/versions.sh'"
  return 1 2>/dev/null || exit 1
fi
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
VERSIONS_FILE="${VERSIONS_FILE:-${ROOT_DIR}/versions.json}"

# Lightweight JSON reader using Python (avoids jq dependency, works cross-platform)
json_get() {
  local key="$1" default_value="${2:-}" file="${3:-$VERSIONS_FILE}"
  python3 - "$key" "$default_value" "$file" <<'PYCODE'
import json, sys, pathlib
key, default, file = sys.argv[1:4]
path = pathlib.Path(file)
if not path.exists():
    print(default)
    sys.exit(0)
with path.open() as f:
    data = json.load(f)
print(data.get(key, default))
PYCODE
}

get_java_version() { json_get javaVersion 21; }
get_boot_preferred_major() { json_get springBootPreferredMajor 4; }
get_boot_fallback() { json_get springBootFallback 4.0.2; }
get_postgres_version() { json_get postgresVersion 16; }
get_temurin_version() { json_get temurinVersion 21; }
get_maven_min_version() { json_get mavenMinVersion 3.8.0; }
get_graalvm_version() { json_get graalvmVersion 25; }
get_node_version() { json_get nodeVersion 22.14.0; }
get_npm_version() { json_get npmVersion 10.10.0; }
get_vite_version() { json_get viteVersion 5; }
get_maven_frontend_plugin_version() { json_get mavenFrontendPluginVersion 1.15.1; }
get_vue_version() { json_get vueVersion 3; }
get_react_version() { json_get reactVersion 18; }
get_angular_version() { json_get angularVersion 19; }
get_testcontainers_version() { json_get testcontainersVersion 2.0.0; }
get_spring_framework_version() { json_get springFrameworkVersion 7.0; }
get_hibernate_version() { json_get hibernateVersion 7.1; }

# Resolve preferred Boot version with fallback. Call: resolve_boot_version [preferred_major]
resolve_boot_version() {
  local preferred_major="${1:-$(get_boot_preferred_major)}" fallback="${2:-$(get_boot_fallback)}"
  # Try to fetch default boot version from start.spring.io metadata
  local fetched_version
  fetched_version=$(curl -s https://start.spring.io -H 'Accept: application/json' |
    grep -o '"bootVersion"[^}]*"default":"[^"]*"' |
    sed 's/.*"default":"\([^"]*\)".*/\1/') || true

  if [[ -z "$fetched_version" ]]; then
    echo "$fallback"
    return
  fi

  # If preferred major matches fetched, use it; else fallback
  if [[ "$fetched_version" == ${preferred_major}.* ]]; then
    echo "$fetched_version"
  else
    >&2 echo "⚠️  start.spring.io default bootVersion ($fetched_version) does not match preferred major $preferred_major. Using fallback $fallback. Override with --boot-version if needed."
    echo "$fallback"
  fi
}

# Normalizes dependency list, ensuring unique, comma-separated values
# Implementation avoids associative arrays for compatibility with older /bin/sh shells
join_dependencies() {
  # Accept comma-separated string(s) and/or space-separated list
  local input="$*"
  input=${input//,/ } # normalize commas to spaces
  local out=""
  for item in $input; do
    [ -z "$item" ] && continue
    case ",$out," in
      *,$item,*) ;; # already present
      *) out="${out:+$out,}$item" ;;
    esac
  done
  echo "$out"
}

export -f json_get get_java_version get_boot_preferred_major get_boot_fallback \
  get_postgres_version get_temurin_version get_maven_min_version get_graalvm_version \
  get_node_version get_npm_version get_vite_version get_maven_frontend_plugin_version \
  get_vue_version get_react_version get_angular_version get_testcontainers_version \
  get_spring_framework_version get_hibernate_version resolve_boot_version join_dependencies
