#!/usr/bin/env bash
set -euo pipefail

# Input: passed via env:
# EV_NAME, EV_CUT, EV_FW, EV_DRY, LBL_BETA, LBL_RC, LBL_PROD, LBL_CAM, LBL_CORE, GITHUB_EVENT_PATH

safe_trim() {
  printf "%s" "$1" | tr -s ' ' | sed 's/^ //; s/ $//'
}

sanitize_aff() {
  case "$1" in
    cam) echo "cam" ;;
    core) echo "core" ;;
    "cam core"|"core cam") echo "cam core" ;;
    *) echo "" ;;
  esac
}

# read labels (one per line)
labels="$(jq -r '.pull_request.labels[].name // empty' "${GITHUB_EVENT_PATH:-/dev/null}" 2>/dev/null | sed '/^\s*$/d' || true)"

cut=""
if [ "${EV_NAME:-}" = "workflow_dispatch" ] && [ -n "${EV_CUT:-}" ]; then
  cut="${EV_CUT}"
else
  if grep -Fxq "${LBL_BETA:-}" <<< "${labels:-}" 2>/dev/null; then cut="beta"; fi
  if grep -Fxq "${LBL_RC:-}" <<< "${labels:-}" 2>/dev/null; then cut="rc"; fi
  if grep -Fxq "${LBL_PROD:-}" <<< "${labels:-}" 2>/dev/null; then cut="prod"; fi
fi

allow=""
if [ "${EV_NAME:-}" = "workflow_dispatch" ] && [ -n "${EV_FW:-}" ]; then
  case "${EV_FW}" in
    camera) allow="cam" ;;
    core) allow="core" ;;
    all) allow="cam core" ;;
  esac
else
  if grep -Fxq "${LBL_CAM:-}" <<< "${labels:-}" 2>/dev/null; then allow="${allow} cam"; fi
  if grep -Fxq "${LBL_CORE:-}" <<< "${labels:-}" 2>/dev/null; then allow="${allow} core"; fi
fi

allow="$(safe_trim "${allow}")"
final="$(sanitize_aff "${allow}")"

# default DRY false if not provided
DRY="${EV_DRY:-false}"

# outputs
echo "cut=${cut:-}" >> "$GITHUB_OUTPUT"
echo "aff=${final:-}" >> "$GITHUB_OUTPUT"
echo "dry=${DRY:-}" >> "$GITHUB_OUTPUT"

if [ -n "${cut:-}" ] && [ -n "${final:-}" ]; then
  echo "should_run=true" >> "$GITHUB_OUTPUT"
else
  echo "should_run=false" >> "$GITHUB_OUTPUT"
fi
