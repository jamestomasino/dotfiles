#!/usr/bin/env bash

################################################################################
################################### HELPERS ####################################
################################################################################

# Helper to test if executable exists
exists() { 
  type -t "$1" > /dev/null 2>&1
}

# Helper to clean vars
trimspace() {
  echo "${@//[[:blank:]]/}"
}

# generate unix timestamp
timestamp() {
  date +"%s"
}

# generic confirmation function
confirm () {
  # call with a prompt string or use a default
  read -r -p "${1:-Are you sure? [y/N]} " response
  case $response in
    [yY][eE][sS]|[yY]) 
      true
      ;;
    *)
      false
      ;;
  esac
}

################################################################################
################################## FUNCTIONS ###################################
################################################################################

for f in "${HOME}/.bash_profile.d/functions/"*; do 
  . "$f"
done
