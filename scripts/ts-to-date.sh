#!/bin/bash

# example
# ts-to-date.sh 1552702680

function get_date() {
  date -j -f "%s" $1 "+%Y-%m-%d %T"
}

get_date $1

