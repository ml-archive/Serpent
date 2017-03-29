#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------

git submodule update --remote

jazzy --swift-version 3.0.2 -o ./ \
      --source-directory Serpent/Serpent \
      --readme Serpent/README.md \
      -a 'Nodes' \
      -u 'https://twitter.com/nodes_ios' \
      -m 'Serpent' \
      -g 'https://github.com/mariusc/Serpent'
