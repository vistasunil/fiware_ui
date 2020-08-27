#!/bin/bash

for (( i=0; i < 60; i=i+5 ));
do
cd /usr/src/app
/usr/local/bin/node public/store.js
diff response.json response.json1

if [ $? -ne 0 ]; then
       	cp response.json1 response.json;
#	ids=$(cat response.json|tr -s ',' '\n'|grep name|awk -F'[: }"]' '{print $6}')
	names=$(cat response.json|tr -s ',' '\n'|grep href|awk -F'[/"]' '{print $6}')
	cat device-monitor.tmp > tmp
	cat iot_token.tmp > iot_tmp
	cat command-listener.tmp > command-listener_tmp
	cat devices.tmp > devices_tmp
	j=1
	for name in $names
	do
		#id=$(echo $name|rev|cut -d':' -f1|rev)
		sed -e "s/device_id1/00$j/g" -e "s/name1/$name/g" device-monitor.tmp2 >> tmp
		sed "s/device_id1/00$j/g" iot_motion.tmp >> iot_tmp
		sed "s/device_id1/00$j/g" iot_lamp.tmp >> iot_tmp
		echo "let motionCounter00$j = 0;" >> command-listener_tmp
                sed "s/device_id1/00$j/g" devices.tmp2 >> devices_tmp
		j=$(expr $j + 1)
        done
	cat command-listener.tmp2 >> command-listener_tmp
	j=1
        for name in $names
        do
		sed "s/device_id1/00$j/g" command-listener.tmp3 >> command-listener_tmp
                j=$(expr $j + 1)
	done
	cat device-monitor.tmp3 >> tmp
	cat command-listener.tmp4 >> command-listener_tmp
	cat devices.tmp3 >> devices_tmp
	cp tmp views/device-monitor.pug
	cp command-listener_tmp controllers/iot/command-listener.js
	cp devices_tmp models/devices.js
	sh iot_tmp
else 
	echo OK; 
fi
	sleep 2
done

