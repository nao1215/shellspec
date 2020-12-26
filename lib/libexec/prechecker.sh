#shellcheck shell=sh

# shellcheck source=lib/semver.sh
. "${SHELLSPEC_LIB:-./lib}/semver.sh"

error() {
  [ $# -gt 0 ] || return 0
  IFS=" $IFS"; "$SHELLSPEC_PRINTF" '%s\n' "$*" >&2; IFS=" ${IFS#?}"
}

warn() {
  [ $# -gt 0 ] || return 0
  IFS=" $IFS"; "$SHELLSPEC_PRINTF" '%s\n' "$*" >&3; IFS=" ${IFS#?}"
}

info() {
  [ $# -gt 0 ] || return 0
  IFS=" $IFS"; "$SHELLSPEC_PRINTF" '%s\n' "$*" >&4; IFS=" ${IFS#?}"
}

abort() {
  [ $# -gt 0 ] || return 0
  case $1 in
    *[!0-9]*) error "$@"; exit 1 ;;
    *) xs=$1; shift ;;
  esac
  [ $# -eq 0 ] && set -- "Aborted (exit status: $xs)"
  error "$@"
  exit "$xs"
}

minimum_version() {
  if [ $# -eq 0 ]; then
    error "minimum_version: The minimum version is not specified"
    return 1
  fi

  if ! check_semver "$1"; then
    error "minimum_version: Invalid version format (major.minor.patch[-pre][+build]): $1"
    return 1
  fi

  semver "$1" -le "$VERSION" && return 0
  error "ShellSpec version $1 or higher is required"
  return 1
}
