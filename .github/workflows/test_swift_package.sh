#!/bin/bash

set -eo pipefail

cd widget-package; swift test --parallel; cd ..
