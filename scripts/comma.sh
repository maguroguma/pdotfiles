#!/bin/bash

awk 'BEGIN { a = "" } NR == 1 { a = a $0 } NR >= 2 { a = a ", " $0 } END { print a }'
