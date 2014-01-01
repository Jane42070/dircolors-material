#!/usr/bin/env bash

function clearScreenWithTime {
  clear
  date
  echo
}

function removeExampleDirs {
  if [ -d "$EXAMPLE_DIR" ]; then
    echoRed "Removing example dirs…"

    for example in "${EXAMPLES[@]}"
      do if [ -d "$EXAMPLE_DIR/$example" ]; then
        rm -r $EXAMPLE_DIR/$example
      fi
    done
  fi
}

function createExampleDirs {
  echoGreen "Creating example dirs…"

  for name in "${EXAMPLES[@]}"
    do mkdir -p $EXAMPLE_DIR/$name
  done
}

function createAllExampleFiles {
  for name in "${EXAMPLES[@]}"
  do
    array="${name^^}_FILES"
    subst="$array[@]"

    createExampleFiles $name ${!subst}
  done
}

function createExampleFiles {
  # First argument are the example name
  name=$1

  # Shift the first argument
  shift

  # Rest of the arguments are files
  files=($@)

  for file in "${files[@]}"
    do touch $EXAMPLE_DIR/$name/$file
  done
}

function createSpecialFiles {
  SPECIAL_DIR=$EXAMPLE_DIR/special

  echoBlue "Creating special files (symlinks, etc)"

  symlinkSpecialFile Gemfile symlink
  createSpecialDir   DIR
  createSpecialFile  NORMAL
  orphanSpecialFile  ORPHAN
  chmodSpecialFile   SETUID u+s
  chmodSpecialFile   SETGID g+s
}

function createSpecialDir {
  mkdir -p $SPECIAL_DIR/$1
}

function createSpecialFile {
  touch $SPECIAL_DIR/$1
}

function symlinkSpecialFile {
  ln -sf $SPECIAL_DIR/$1 $SPECIAL_DIR/$2
}

function orphanSpecialFile {
  ORPHAN_TARGET=$SPECIAL_DIR/$1_TARGET

  touch $ORPHAN_TARGET

  ln -sf $ORPHAN_TARGET $SPECIAL_DIR/$1

  rm $ORPHAN_TARGET
}

function chmodSpecialFile {
  touch $SPECIAL_DIR/$1
  chmod $2 $SPECIAL_DIR/$1
}

function reloadDircolors {
  GENERATED_DIRCOLORS=$EXAMPLE_DIR.generated

  cat $SCRIPT_DIR/../dircolors.jellybeans \
      $SCRIPT_DIR/dircolors.all_colors > $GENERATED_DIRCOLORS

  echo -e "\nReloading dircolors!  ゜ﾟ･ ヽ(⊙ ‿ ⊙)ノ ･゜ﾟ\n"

  eval $(dircolors $GENERATED_DIRCOLORS)
}

function listDir {
  ls --color -AF $1
}

COLUMNS=`tput cols`

function showDir {
  NAME_LENGTH=${#1}
  COUNT=$((COLUMNS-NAME_LENGTH-3))

  printf "\e[1;30m— $1 "
  printf '%0.s—' $(seq 1 $COUNT)
  printf "\e[0m"

  if [ -n "$2" ]; then
    listDir $2
  else
    listDir $EXAMPLE_DIR/$1
  fi
}

function showRealDir {
  showDir $1 $1
}

function showExampleDirs {
  for name in "${EXAMPLES[@]}"
    do showDir $name
  done
}

function echoRed {
  echo -e "$3\e[0;31m$1\e[0m$2"
}

function echoGreen {
  echo -e "$3\e[0;32m$1\e[0m$2"
}

function echoBlue {
  echo -e "$3\e[1;34m$1\e[0m$2"
}