#!/bin/bash

rsync -ravu --stats --progress --exclude=install.sh ./ /Applications/Arduino.app/Contents/Resources/Java/libraries/

