#!/usr/bin/env bash

cd $(dirname $BASH_SOURCE[0])
sudo nix flake update
