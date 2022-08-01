#!/bin/bash

tac $HOME/.zhistory | cut -b 16- | head -n 5000
