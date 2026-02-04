#!/usr/bin/env bash
set -eo pipefail

REPO_URL="https://github.com/guruvamsi-policharla/paper-review-skill.git"
SKILL_NAME="paper-review"
TMP_DIR=""

cleanup() {
  [[ -n "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
}
trap cleanup EXIT

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Install the Paper Review skill for OpenCode, Claude Code, and/or OpenAI Codex.

Options:
  -g, --global      Install globally (default)
  -l, --local       Install locally (current project only)
  --opencode        Install for OpenCode only
  --claude          Install for Claude Code only
  --codex           Install for OpenAI Codex only
  -h, --help        Show this help message

By default, installs for OpenCode, Claude Code, and OpenAI Codex.

Examples:
  curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash -s -- --local
  curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash -s -- --codex
EOF
}

install_for_opencode() {
  local install_type="$1"
  local skill_dir command_dir

  if [[ "$install_type" == "global" ]]; then
    skill_dir="${HOME}/.config/opencode/skills"
    command_dir="${HOME}/.config/opencode/command"
  else
    skill_dir=".opencode/skills"
    command_dir=".opencode/command"
  fi

  local skill_path="${skill_dir}/${SKILL_NAME}"
  local command_path="${command_dir}/${SKILL_NAME}.md"

  mkdir -p "$skill_dir" "$command_dir"

  [[ -d "$skill_path" ]] && rm -rf "$skill_path"
  [[ -f "$command_path" ]] && rm -f "$command_path"

  cp -r "${TMP_DIR}/skills/${SKILL_NAME}" "$skill_path"
  cp "${TMP_DIR}/command/${SKILL_NAME}.md" "$command_path"

  echo "  OpenCode skill: ${skill_path}"
  echo "  OpenCode command: ${command_path}"
}

install_for_claude() {
  local install_type="$1"
  local skill_dir

  if [[ "$install_type" == "global" ]]; then
    skill_dir="${HOME}/.claude/skills"
  else
    skill_dir=".claude/skills"
  fi

  local skill_path="${skill_dir}/${SKILL_NAME}"

  mkdir -p "$skill_dir"

  [[ -d "$skill_path" ]] && rm -rf "$skill_path"

  cp -r "${TMP_DIR}/skills/${SKILL_NAME}" "$skill_path"

  echo "  Claude Code skill: ${skill_path}"
}

install_for_codex() {
  local install_type="$1"
  local skill_dir

  if [[ "$install_type" == "global" ]]; then
    skill_dir="${HOME}/.agents/skills"
  else
    skill_dir=".agents/skills"
  fi

  local skill_path="${skill_dir}/${SKILL_NAME}"

  mkdir -p "$skill_dir"

  [[ -d "$skill_path" ]] && rm -rf "$skill_path"

  cp -r "${TMP_DIR}/skills/${SKILL_NAME}" "$skill_path"

  echo "  OpenAI Codex skill: ${skill_path}"
}

main() {
  local install_type="global"
  local install_opencode=true
  local install_claude=true
  local install_codex=true

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -g|--global) install_type="global"; shift ;;
      -l|--local) install_type="local"; shift ;;
      --opencode) install_opencode=true; install_claude=false; install_codex=false; shift ;;
      --claude) install_claude=true; install_opencode=false; install_codex=false; shift ;;
      --codex) install_codex=true; install_opencode=false; install_claude=false; shift ;;
      -h|--help) usage; exit 0 ;;
      *) echo "Unknown option: $1"; usage; exit 1 ;;
    esac
  done

  echo "Installing ${SKILL_NAME} skill (${install_type})..."

  # Create temp directory
  TMP_DIR=$(mktemp -d)

  # Clone repo
  echo "Fetching skill..."
  git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR"

  echo "Installing to:"

  if [[ "$install_opencode" == true ]]; then
    install_for_opencode "$install_type"
  fi

  if [[ "$install_claude" == true ]]; then
    install_for_claude "$install_type"
  fi

  if [[ "$install_codex" == true ]]; then
    install_for_codex "$install_type"
  fi

  echo ""
  echo "Done! Use /paper-review (OpenCode) or \$paper-review (Codex) to review a LaTeX paper."
}

main "$@"
