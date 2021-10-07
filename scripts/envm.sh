#!/usr/bin/env bash

autoload -U add-zsh-hook

envm() {
  out=$(envm-exec  "$@")

  # Not in path operations, so just print it.
  if [[ $? == 1 || $1 == "list" || $1 == "help" ]]; then
    echo "$out"
  else # Path operations. Export the return values as PATH.
    export PATH="$out"
  fi
}

# To load initially when the shell initialzes
envm init

# Runs everytime when we do 'cd'
add-zsh-hook chpwd () {
  envm init
}
