#!/usr/bin/env bash
# scripts/files.sh
#
# Read-only file search and display utilities.
# Wraps find, grep, and cat so agents avoid raw shell operators.
#
# Usage:
#   ./scripts/files.sh find <pattern> [path]           # find files by glob
#   ./scripts/files.sh grep <pattern> [path] [--name <glob>]  # search contents
#   ./scripts/files.sh cat <file> [file...]             # display file(s)
#
# Examples:
#   ./scripts/files.sh find "*.dart" lib/
#   ./scripts/files.sh find "pubspec.yaml"
#   ./scripts/files.sh grep "class MyWidget" lib/src/
#   ./scripts/files.sh grep "TODO" --name "*.dart"
#   ./scripts/files.sh cat pubspec.yaml
#   ./scripts/files.sh cat lib/src/foo.dart test/src/foo_test.dart

set -euo pipefail
exec 2>&1

CMD="${1:-help}"
shift || true

case "$CMD" in
  find)
    PATTERN="${1:?Usage: files.sh find <pattern> [path]}"
    SEARCH_PATH="${2:-.}"
    find "$SEARCH_PATH" -name "$PATTERN" -not -path '*/.*' -not -path '*/build/*' | sort
    ;;

  grep)
    PATTERN="${1:?Usage: files.sh grep <pattern> [path] [--name <glob>]}"
    shift
    SEARCH_PATH="."
    NAME_ARGS=()

    while [ $# -gt 0 ]; do
      case "$1" in
        --name) NAME_ARGS=("--include" "$2"); shift 2 ;;
        *)      SEARCH_PATH="$1"; shift ;;
      esac
    done

    if [ ${#NAME_ARGS[@]} -gt 0 ]; then
      grep -rn "$PATTERN" "$SEARCH_PATH" "${NAME_ARGS[@]}" --color=never || echo "(no matches)"
    else
      grep -rn "$PATTERN" "$SEARCH_PATH" --color=never || echo "(no matches)"
    fi
    ;;

  cat)
    if [ $# -eq 0 ]; then
      echo "Usage: files.sh cat <file> [file...]"
      exit 1
    fi
    for file in "$@"; do
      if [ ! -f "$file" ]; then
        echo "ERROR: $file not found"
        exit 1
      fi
      if [ $# -gt 1 ]; then
        echo "=== $file ==="
      fi
      cat -n "$file"
      if [ $# -gt 1 ]; then
        echo ""
      fi
    done
    ;;

  help|*)
    echo "Usage: files.sh {find|grep|cat} [args]"
    echo ""
    echo "Commands:"
    echo "  find <pattern> [path]                 Find files by glob pattern"
    echo "  grep <pattern> [path] [--name <glob>] Search file contents"
    echo "  cat <file> [file...]                  Display file(s) with line numbers"
    exit 1
    ;;
esac
