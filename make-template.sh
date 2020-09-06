#!/bin/bash
################################################################################
#	This bash scritp will generate the xml template for zabbix version 5.0     #
#	The input file is the export of metrics from the Jenkins Metrics Plugin    #
#	The input file could be generated using the script provided by "   "       #
#	                         DO NOT USE                                        #
#	                ******still in progres*****                                #
#	               written by Mohammadmahmoud Agahi							   #
#                                                                              #
################################################################################

## The following Variables will determine which keywords to be ignored in the metrics file
b1="units="
b2="version"
b3="m1"
b4="m5"
b5="1m"
b6="5m"
b7="15m"
b8="1h"
b9="histogram"

function extract_items {
while IFS= read -r line 
	do
    	line=`echo $line | cut -d "=" -f 1`
		application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
    	metric=$line
    	name=`echo $line | cut -d "." -f 4,5 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g" | cut -d "=" -f 1`
		units="0" 
	    vtype="0"
		name_addition=""

		if  echo $line | egrep "$b1|$b2|$b3|$b4|$b5|$b6|$b7|$b8|$b9"   > /dev/null
		then
    		continue
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 3 ]
		then
			application=`echo $line | cut -d "." -f 1 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
			name=`echo $line | cut -d "." -f 2,3  | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 4 ]
		then
			application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
			name=`echo $line | cut -d "." -f 3,4  | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 5 ]
		then
			application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
			name=`echo $line | cut -d "." -f 3,4,5  | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 6 ]
		then
			application=`echo $line | cut -d "." -f 2,3,4 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
			name=`echo $line | cut -d "." -f 5,6  | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 7 ]
		then
			application=`echo $line | cut -d "." -f 2,3,4,5 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
			name=`echo $line | cut -d "." -f 6,7  | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		else
			continue
		fi
		
		if echo $line | grep "\.rate" | grep "mean" > /dev/null; then
   			units=`grep $(echo $line | cut -d "." -f 1,2,3,4,5) $1 | grep unit | cut -d "=" -f 2` 
	   		vtype="FLOAT"
    		name_addition=" (mean rate)"
		elif echo $line | grep "count" > /dev/null; then
   			if echo $line | grep "duration" > /dev/null; then
				units="seconds"
       		fi
		elif echo $line | grep mean_rate > /dev/null; then
    			vtype="FLOAT"
    			units="seconds"
    			name_addition=" (mean)"
		else
    		continue
		fi

		echo "				<item>
                	<name>$name$name_addition</name>
                	<key>jenkins.metrics[$metric]</key>"
		if [[ $vtype != "0" ]]
		then
            echo "					<value_type>$vtype</value_type>"
        fi
		if [[ $units != "0" ]]
		then
		    echo "					<units>$units</units>"
		fi
		echo "					<applications>
                    	<application>
                        	<name>$application</name>
                    	</application>
                	</applications>
            	</item>"
	done < $1
}

function extract_applications {
	touch /tmp/application_temp
	> /tmp/application_temp
	while IFS= read -r line 
	do
   		application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
        
		if  echo $line | egrep "$b1|$b2|$b3|$b4|$b5|$b6|$b7|$b8|$b9"   > /dev/null
		then
    		continue
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 3 ]
		then
			application=`echo $line | cut -d "." -f 1 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 4 ]
		then
			application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 5 ]
		then
			application=`echo $line | cut -d "." -f 2,3 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 6 ]
		then
			application=`echo $line | cut -d "." -f 2,3,4 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		elif [ `echo $line |  grep -o "\." | wc -l` -eq 7 ]
		then
			application=`echo $line | cut -d "." -f 2,3,4,5 | sed 's/\./ /g' | sed -e "s/\b\(.\)/\u\1/g"`
		else
			continue
		fi

        echo $application >> /tmp/application_temp
	done < $1

	cat /tmp/application_temp | sort -u | grep -v "0" > /tmp/application_temp1
	
	while IFS= read -r application 
	do
		echo "                <application>
                    <name>$application</name>
                </application>"
	done < /tmp/application_temp1

	rm -rf /tmp/application_temp*
}

function make_output {
	cat << EOF
<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export>
    <version>5.0</version>
    <date>2020-09-04T06:27:13Z</date>
    <groups>
        <group>
            <name>Templates/Applications</name>
        </group>
    </groups>
    <templates>
        <template>
            <template>jenkins-metrics</template>
            <name>Jenkins Metrics</name>
            <groups>
                <group>
                    <name>Templates/Applications</name>
                </group>
            </groups>
            <applications>
EOF
extract_applications $1
cat << EOF
            </applications>
			<items>
EOF
extract_items $1
cat << EOF
            </items>
        </template>
    </templates>
</zabbix_export>
EOF
}


make_output $1
