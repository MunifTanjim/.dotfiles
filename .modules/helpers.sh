function command_exists() {
  type "${1}" >/dev/null 2>&1
}

function directory_exists() {
  [ -d "${1}" ]
}

if ! command_exists pathmunge; then
  function pathmunge() {
    if ! [[ ${PATH} =~ (^|:)${1}($|:) ]]; then
      if directory_exists "${1}"; then
        if [ "${2}" = "after" ]; then
          export PATH="${PATH}:${1}"
        else
          export PATH="${1}:${PATH}"
        fi
      fi
    fi
  }
fi

