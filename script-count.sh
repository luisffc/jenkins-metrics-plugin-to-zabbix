#!/bin/bash

while IFS= read -r line 
do
    application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
    metric=`echo $line | cut -d "=" -f 1`
    name=`echo $line | cut -d "." -f 4,5 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g" `
    echo "            <item>
                <name>$name</name>
                <key>jenkins.metrics[$metric]</key>
                <applications>
                    <application>
                        <name>$application</name>
                    </application>
                </applications>
            </item>"
done < $1
