#!/bin/bash

# example
# date-to-ts.sh "2019-03-16 11:18:00"

function get_timestamp() {
  arg="$1 $2"
  date -j -f "%Y-%m-%d %T" "$arg" "+%s"
}

get_timestamp $1

