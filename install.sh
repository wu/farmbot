#!/bin/bash

installpath="/Applications/Arduino.app/Contents/Resources/Java/libraries/"

for lib in WubotHumidity WubotSoilMoisture WubotTemperature WubotStatusLight
do

    echo "#####################"
    echo "Installing lib: $lib"

    #if [ -r $installpath/$lib ]
    #then
    #    diff -rwu $installpath/$lib $lib
    #fi


    rsync -ravu $lib $installpath

done

echo "#####################"
