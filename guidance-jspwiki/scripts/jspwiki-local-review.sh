#!/bin/zsh

set -euo pipefail

REPO_ROOT="/Users/pappmico/Documents/repo/guidance/jspwiki"

usage() {
  printf 'Usage: %s <path|baseline|diff|final> "Page Title"\n' "$0" >&2
  exit 1
}

sanitize_page_title() {
  local input="$1"
  local sanitized

  sanitized=$(printf '%s' "$input" \
    | tr ' /' '__' \
    | tr -cs 'A-Za-z0-9._-' '_' \
    | sed -E 's/_+/_/g; s/^_+//; s/_+$//')

  if [[ -z "$sanitized" ]]; then
    printf 'Could not derive a safe file name from page title: %s\n' "$input" >&2
    exit 1
  fi

  printf '%s/%s.txt\n' "$REPO_ROOT" "$sanitized"
}

ensure_repo() {
  if ! git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf 'Not a git repository: %s\n' "$REPO_ROOT" >&2
    exit 1
  fi
}

commit_file() {
  local file_path="$1"
  local commit_prefix="$2"
  local page_title="$3"
  local relative_path

  if [[ ! -f "$file_path" ]]; then
    printf 'Missing file: %s\n' "$file_path" >&2
    exit 1
  fi

  relative_path="${file_path#${REPO_ROOT}/}"

  git -C "$REPO_ROOT" add -- "$relative_path"

  if git -C "$REPO_ROOT" diff --cached --quiet -- "$relative_path"; then
    printf 'No staged changes for %s\n' "$file_path"
    exit 0
  fi

  git -C "$REPO_ROOT" commit -m "[jspwiki] ${commit_prefix}: ${page_title}" -- "$relative_path"
}

main() {
  local action="${1:-}"
  local page_title="${2:-}"

  [[ -n "$action" && -n "$page_title" ]] || usage

  ensure_repo

  local file_path
  file_path=$(sanitize_page_title "$page_title")

  case "$action" in
    path)
      printf '%s\n' "$file_path"
      ;;
    baseline)
      commit_file "$file_path" "Baseline" "$page_title"
      ;;
    diff)
      local relative_path

      if [[ ! -f "$file_path" ]]; then
        printf 'Missing file: %s\n' "$file_path" >&2
        exit 1
      fi

      relative_path="${file_path#${REPO_ROOT}/}"

      git -C "$REPO_ROOT" diff -- "$relative_path"
      ;;
    final)
      commit_file "$file_path" "Update" "$page_title"
      ;;
    *)
      usage
      ;;
  esac
}

main "$@"
