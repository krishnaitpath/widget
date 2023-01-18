#!/bin/bash

set -eo pipefail

xcodebuild -workspace widget.xcworkspace \
            -scheme widget\ iOS \
            -destination platform=iOS\ Simulator,OS=15.2,name=iPhone\ 11 \
            clean test | xcpretty
