#!/usr/bin/env -S zsh -f

# kit-tools loader (single source of truth)
#
# Usage (from anywhere):
#   source "$AGENT_KIT_HOME/scripts/kit-tools.sh"
#
# Contract:
# - Hard-fails with actionable errors when required tools are unavailable.
# - Sets/exports AGENT_KIT_HOME (if missing) and ensures repo-local tools are on PATH.

if [[ -n "${_kit_tools_loader_loaded-}" ]]; then
  return 0 2>/dev/null || exit 0
fi
typeset -gr _kit_tools_loader_loaded=1

_kit_tools_die() {
  emulate -L zsh
  setopt err_return no_unset

  local message="${1-}"
  if [[ -z "$message" ]]; then
    message="unknown error"
  fi

  print -u2 -r -- "error: ${message}"
  return 1 2>/dev/null || exit 1
}

_kit_tools_note() {
  emulate -L zsh
  setopt err_return no_unset
  print -u2 -r -- "$*"
}

if [[ -z "${ZSH_VERSION:-}" ]]; then
  _kit_tools_die "must be sourced in zsh (try: zsh -lc 'source <path>/scripts/kit-tools.sh')"
fi

# Resolve AGENT_KIT_HOME from this file location if missing.
if [[ -z "${AGENT_KIT_HOME:-}" ]]; then
  export AGENT_KIT_HOME="${${(%):-%x}:A:h:h}"
fi

if [[ -z "${AGENT_KIT_HOME:-}" || ! -d "${AGENT_KIT_HOME:-}" ]]; then
  _kit_tools_die "AGENT_KIT_HOME is not set or invalid; set AGENT_KIT_HOME to the repo root"
fi

export AGENT_KIT_HOME

typeset -g _kit_env_file="${AGENT_KIT_HOME%/}/scripts/env.zsh"
if [[ -f "$_kit_env_file" ]]; then
  # shellcheck disable=SC1090
  source "$_kit_env_file" || _kit_tools_die "failed to source ${_kit_env_file}"
fi

typeset -g _kit_bin_dir="${AGENT_KIT_HOME%/}/scripts/commands"
if [[ ! -d "$_kit_bin_dir" ]]; then
  _kit_tools_note "missing tools bin dir: ${_kit_bin_dir} (creating)"
  mkdir -p -- "$_kit_bin_dir" || _kit_tools_die "failed to create tools bin dir: ${_kit_bin_dir}"
fi

if [[ ":${PATH}:" != *":${_kit_bin_dir}:"* ]]; then
  export PATH="${_kit_bin_dir}:${PATH}"
fi

typeset -g ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export ZDOTDIR
export ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-$ZDOTDIR/cache}"

typeset -g _kit_wrapper_dir="${ZSH_CACHE_DIR%/}/wrappers/bin"
typeset -g _kit_bundler="${AGENT_KIT_HOME%/}/scripts/build/bundle-wrapper.zsh"

_kit_tools_bundle() {
  emulate -L zsh
  setopt err_return no_unset

  local name="${1-}"
  local entry="${2-}"
  local wrapper="${_kit_wrapper_dir%/}/${name}"
  local output="${_kit_bin_dir%/}/${name}"

  [[ -n "$name" && -n "$entry" ]] || return 1
  [[ -x "$output" ]] && return 0
  [[ -f "$wrapper" ]] || return 1

  if [[ ! -f "$_kit_bundler" ]]; then
    _kit_tools_die "missing bundler: ${_kit_bundler}"
  fi

  _kit_tools_note "bundling ${name} from ${wrapper}"
  zsh -f "$_kit_bundler" --input "$wrapper" --output "$output" --entry "$entry" \
    || _kit_tools_die "failed to bundle ${name}"
}

_kit_tools_require() {
  emulate -L zsh
  setopt err_return no_unset

  local name="${1-}"
  local entry="${2-}"
  local output="${_kit_bin_dir%/}/${name}"

  if ! command -v "$name" >/dev/null 2>&1; then
    _kit_tools_bundle "$name" "$entry" || {
      _kit_tools_note "hint: expected executable: ${output}"
      _kit_tools_note "hint: fix: chmod +x \"${output}\""
      _kit_tools_die "required tool missing: ${name}"
    }
  fi
}

# Validate required commands/functions are present after loading tools.
_kit_tools_require "git-tools" "git-tools"
_kit_tools_require "git-scope" "git-scope"

if ! command -v git >/dev/null 2>&1; then
  _kit_tools_die "required tool missing: git"
fi
