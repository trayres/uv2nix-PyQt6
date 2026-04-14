#!/usr/bin/env sh
#

nix bundle --bundler github:NixOS/bundlers#toAppImage .#default
