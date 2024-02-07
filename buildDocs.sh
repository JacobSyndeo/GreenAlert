#!/bin/sh

swift package --allow-writing-to-directory ./docs \
              generate-documentation --target GreenAlert \
              --disable-indexing \
              --transform-for-static-hosting \
              --hosting-base-path / \
              --output-path ./docs \
              --include-extended-types
