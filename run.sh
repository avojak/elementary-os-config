#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Must run as root!"
  exit 1
fi
