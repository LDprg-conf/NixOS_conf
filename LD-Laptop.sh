#!/usr/bin/env bash

cd $( dirname $BASH_SOURCE[0] )
sudo nixos-rebuild switch --flake .#LD-Laptop $@
