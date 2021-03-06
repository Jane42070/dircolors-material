#!/usr/bin/env zsh

# Standarized $0 handling, following:
# https://github.com/zdharma/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
_DIRNAME="${0:h}"

if [[ ! -f "${TMPDIR:-/tmp}/.material-dircolors-cache-${USER}.zsh" ]]; then
  if (( $+commands[dircolors] )); then
    dircolors "${_DIRNAME}/material.dircolors" > "${TMPDIR:-/tmp}/.material-dircolors-cache-${USER}.zsh"
  elif (( $+commands[gdircolors] )); then
    gdircolors "${_DIRNAME}/material.dircolors" > "${TMPDIR:-/tmp}/.material-dircolors-cache-${USER}.zsh"
  fi
fi
source "${TMPDIR:-/tmp}/.material-dircolors-cache-${USER}.zsh"

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
