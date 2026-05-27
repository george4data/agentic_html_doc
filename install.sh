#!/usr/bin/env bash
# Install the "agentdocs" skill into a Claude skills directory.
#
#   ./install.sh              # personal install -> ~/.claude/skills/agentdocs
#   ./install.sh --project    # project install  -> ./.claude/skills/agentdocs
#
# Works from a clone OR piped from the web:
#   curl -fsSL https://raw.githubusercontent.com/george4data/agentic_html_doc/main/install.sh | bash
set -euo pipefail

SKILL_NAME="agentdocs"
REPO="https://github.com/george4data/agentic_html_doc"

# Destination: personal by default, project with --project
DEST="${HOME}/.claude/skills"
if [ "${1:-}" = "--project" ]; then DEST="$(pwd)/.claude/skills"; fi

# Source: use the local clone if this script sits next to skills/, else clone to temp
SRC=""
CLEANUP=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "${SCRIPT_DIR}" ] && [ -d "${SCRIPT_DIR}/skills/${SKILL_NAME}" ]; then
  SRC="${SCRIPT_DIR}/skills/${SKILL_NAME}"
else
  command -v git >/dev/null 2>&1 || { echo "git is required" >&2; exit 1; }
  TMP="$(mktemp -d)"; CLEANUP="${TMP}"
  git clone --depth 1 "${REPO}" "${TMP}" >/dev/null 2>&1
  SRC="${TMP}/skills/${SKILL_NAME}"
fi

[ -d "${SRC}" ] || { echo "skill not found at ${SRC}" >&2; exit 1; }

mkdir -p "${DEST}"
rm -rf "${DEST:?}/${SKILL_NAME}"
cp -R "${SRC}" "${DEST}/${SKILL_NAME}"
[ -n "${CLEANUP}" ] && rm -rf "${CLEANUP}"

echo "Installed '${SKILL_NAME}' -> ${DEST}/${SKILL_NAME}"
echo "Restart your Claude session, then ask: \"use agentdocs to validate templates/standard.html\""
