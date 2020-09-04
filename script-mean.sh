#!/bin/bash

while IFS= read -r line 
do
    application=`echo $line | cut -d "-" -f 1`
    metric=`echo $line | cut -d "-" -f 2`
    name=`echo $line | cut -d "-" -f 3`
    echo "            <item>
                <name>$name (mean)</name>
                <key>jenkins.metrics[$metric]</key>
                <value_type>FLOAT</value_type>
                <units>events/minute</units>
                <applications>
                    <application>
                        <name>$application</name>
                    </application>
                </applications>
            </item>"
done < $1
