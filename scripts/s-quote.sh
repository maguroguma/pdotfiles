#!/bin/bash

awk '{ print "\047" $0 "\047" }'
