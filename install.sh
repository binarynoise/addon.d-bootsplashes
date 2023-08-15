#!/bin/bash

set -eu
set -x

zip -r -o addond-bootsplashes.zip --filesync . -x install.sh -x addond-bootsplashes.sh -x .git/* -x@.gitignore
adb devices | grep -qe recovery -e unauthorized || adb reboot recovery
adb wait-for-sideload
adb sideload addond-bootsplashes.zip
