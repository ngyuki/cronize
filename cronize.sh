#!/bin/bash

set -eu

usage() {
  echo "Usage: ${0##*/} [-h] [-t tag] command args..." 1>&2
  exit 1
}

tag=

while getopts t:h OPT; do
  case "$OPT" in
    t) tag=$OPTARG ;;
    *) usage ;;
  esac
done

shift $((OPTIND - 1))

if [ $# -eq 0 ]; then
  usage
fi

if [ -z "$tag" ]; then
  tag="${1##*/}"
fi

{
  {
    "$@" || echo -e "===\nJob is failed ($?)" 1>&2
  } 3>&2 2>&1 1>&3 |
    /usr/bin/tee /dev/stderr
} 3>&2 2>&1 1>&3 |
  /usr/bin/logger -i -t "$tag"
