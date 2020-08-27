#!/bin/bash

cat views/device-monitor.tmp > tmp
sed 's/device_id/$id/g' views/device-monitor.tmp2 >> tmp
cat views/device-monitor.tmp3 >> tmp
