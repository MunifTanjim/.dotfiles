#!/usr/bin/env bash

# Return if not interactive shell
[[ $- != *i* ]] && return

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export DOTFILES="${HOME}/.dotfiles"

source "${DOTFILES}/scripts/paths.bash"
source "${DOTFILES}/modules/init.sh"
