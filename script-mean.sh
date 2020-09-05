#!/bin/bash
b1="units="
b2="value"
b3="m1"
b4="m5"
b5="1m"
b6="5m"
b7="15m"
b8="1h"



while IFS= read -r line 
do
    
    application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
    metric=`echo $line | cut -d "=" -f 1`
    name=`echo $line | cut -d "." -f 4,5 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
    if  echo $line | egrep "$b(seq 1 8)"   > /dev/null
    then
	    continue
    elif  echo $line | grep "\.rate" | grep "mean" > /dev/null
    then
	    units=`grep $(echo $line | cut -d "." -f 1,2,3,4,5) $1 | grep unit | cut -d "=" -f 2` 
	    vtype="FLOAT"
	    name_addition=" (mean rate)"
    elif echo $line | grep count > /dev/null
    then
	    vtype=""
	    units=""
	    name_addition=""
	    if echo $line | grep count | grep duration > /dev/null
	    then
		    unist="seconds"
            fi
    elif echo $line | grep mean_rate > /dev/null
    then
	    vtype="FLOAT"
	    units="seconds"
	    name_addition=" (mean)"
    else
	    continue
    fi
    echo "            <item>
                <name>$name$name_addition</name>
                <key>jenkins.metrics[$metric]</key>
                <value_type>$vtype</value_type>
                <units>$units</units>
                <applications>
                    <application>
                        <name>$application</name>
                    </application>
                </applications>
            </item>"
done < $1
