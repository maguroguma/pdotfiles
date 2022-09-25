#!/bin/bash

# cat {{ file-name }} | s-quote.sh

awk '{ print "\047" $0 "\047" }'
