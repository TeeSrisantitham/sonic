#!/usr/bin/env bash

svm() {
  if [ $# -lt 1 ]; then
    svm --help
    return
  fi

  local i

  for i in "$@"
  do
    case $i in 
      '-h'|'help'|'--help')
        echo 'Usage:'
        echo '  svm --help                                  Show this message'
        echo '  svm create <project name>                   Install sonic'
        return
        ;;
      *)
    esac
  done

  local COMMAND
  COMMAND="${1}"

  case $COMMAND in 
    'create' | 'i')
      create "${2}"
      ;;
    *)
      hander_err "Command ${COMMAND} is not found"
      ;;
  esac
}

hander_err ()
{
  local ERROR_MSG
  ERROR_MSG="${1}"

  echo "=> Error: ${ERROR_MSG}" 
}

create ()
{
  local DESTINATION
  DESTINATION="$1"
  local DIR
  local ADDR

  IFS='/'
  read -A ADDR <<< "$DESTINATION"
  DIR=${ADDR[${#ADDR[@]}]}

  echo "=> Creating ${DIR}"

  cp -r $HOME/.svm/skel ${DIR}
  sed -i -e "s|github.com/openware/sonic/skel|${DESTINATION}|g" ${DIR}/**/*.go ${DIR}/go.mod
  git init -q ${DIR}

  echo "=> Done"
}
