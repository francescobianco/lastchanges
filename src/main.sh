
main() {
  local path

  path=$(realpath "${1:-/}")

  echo "Checking path: ${path}"

  # Check if the path is a directory


  root_index=0
  root_count=$(find "${path}" -maxdepth 1 -type d | wc -l)

  root_depth=0
  path_depth=$(echo "${path}" | awk -F'/' '{print NF-1}')
  open_count=0
  find "${path}" -type d | while IFS= read -r dir; do
    [ "${dir}" = "${path}" ] && continue
    root_depth=$(echo "${dir}" | awk -F'/' '{print NF-1}')
    find "${dir}" -type f -exec stat -c '%Y %n' {} \; >/dev/null 2>&1 || true
    root_delta=$((root_depth - path_depth))
    if [ "${root_delta}" -eq 1 ]; then
      root_index=$((root_index + 1))
      echo "Progress:  ${root_index}/${root_count} ${root_depth}/${path_depth}  $((root_index * 100 / root_count))%  ${dir}"
    fi
    if [ "${root_delta}" -eq 2 ]; then
      if [ ${open_count} -eq 0 ]; then
        #echo "A"
        echo "Delta 2: NULL  ${dir}"
      else
        echo "Delta 2: CLOSE  ${dir}"
        open_count=0
      fi
    fi
    if [ "${root_delta}" -eq 3 ]; then
      echo "Delta 3: OPEN   ${dir}"
      open_count=1
    fi

  done

  echo "OK!"

}


# find / -type d -exec stat -c '%Y %n' {} \;