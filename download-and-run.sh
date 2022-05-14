#!/bin/bash

name=elementary-os-config
branch=master
archive=$name.zip
directory=$name-$branch

# Download and extract the tool
wget -q -O $archive https://github.com/avojak/$name/archive/refs/heads/$branch.zip
unzip -qq $archive

# Run the configuration
cd $directory && ./run.sh

# Cleanup
cd ..
rm -rf $archive $directory