#!/bin/bash

set -eo pipefail

xcodebuild -workspace widget.xcworkspace \
            -scheme widget\ iOS \
            -sdk iphoneos \
            -configuration AppStoreDistribution \
            -archivePath $PWD/build/Calculator.xcarchive \
            clean archive | xcpretty
