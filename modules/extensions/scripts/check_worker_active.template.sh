#!/usr/bin/env bash
# Copyright 2017, 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl
# shellcheck disable=SC1083,SC2309,SC2154,SC2157,SC2034 # Ignore templated/escaped/unused file variables
export ALL_FILE=~/all_node.active ONE_FILE=~/one_node.active

function clean_node_active() {
  rm -f "$${ALL_FILE}" "$${ONE_FILE}"
}

function get_actual_node_count() {
  (kubectl get --no-headers nodes | grep -v NotReady | awk '{print $1}' | wc -l) 2>/dev/null || echo '0'
}

function wait_for_active() {
  clean_node_active

  while true; do
    local actual_node_count
    actual_node_count=$(get_actual_node_count)
    if [[ $${actual_node_count} -ge ${expected_node_count} ]]; then touch all_node.active; fi
    if [[ $${actual_node_count} -ge 1 ]]; then touch one_node.active; fi

    if [[ -f "$${ONE_FILE}" ]] && [[ "${check_node_active}" == 'one' ]]; then
      echo "Ready with $${actual_node_count} node(s)"
      break
    fi

    if [[ -f "$${ALL_FILE}" ]] && [[ "${check_node_active}" == 'all' ]]; then
      echo "Ready with $${actual_node_count} node(s)"
      break
    fi

    echo "$(date): Waiting for ${check_node_active} of ${expected_node_count} node(s) to become ready ($${actual_node_count} found)"
    sleep 30
  done
}

if [[ ${expected_node_count} -ge 1 ]]; then time wait_for_active; fi