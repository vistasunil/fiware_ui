#!/bin/bash
#
#  curl commands to reload the data from the previous tutorial
#
#

set -e

printf "⏳ Loading cIOT Devices Data "

#
# Create IOT Devices in various Streetlights
#

#curl -X DELETE   'http://iot-agent:4041/iot/devices/motion001'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X DELETE   'http://iot-agent:4041/iot/devices/motion002'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X DELETE   'http://iot-agent:4041/iot/devices/motion003'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X DELETE   'http://iot-agent:4041/iot/devices/motion004'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X DELETE   'http://iot-agent:4041/iot/devices/lamp001'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X DELETE   'http://iot-agent:4041/iot/devices/lamp002'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X DELETE   'http://iot-agent:4041/iot/devices/lamp003'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X DELETE   'http://iot-agent:4041/iot/devices/lamp004'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'
#curl -X GET   'http://iot-agent:4041/iot/devices'   -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'

curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/services' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
 "services": [
   {
     "apikey":      "4jggokgpepnvsb2uv4s40d59ov",
     "cbroker":     "http://orion:1026",
     "entity_type": "Thing",
     "resource":    "/iot/d"
   }
 ]
}'

curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
 "devices": [
   {
     "device_id":   "motion001",
     "entity_name": "urn:ngsi-ld:Motion:001",
     "entity_type": "Motion",
     "timezone":    "Europe/Berlin",
     "attributes": [
       { "object_id": "c", "name": "count", "type": "Integer" }
     ],
     "static_attributes": [
       { "name":"refStore", "type": "Relationship", "value": "urn:ngsi-ld:Streetlight:streetlight:001"}
     ]
   }
 ]
}
'

curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
 "devices": [
   {
     "device_id":   "motion002",
     "entity_name": "urn:ngsi-ld:Motion:002",
     "entity_type": "Motion",
     "timezone":    "Europe/Berlin",
     "attributes": [
       { "object_id": "c", "name": "count", "type": "Integer" }
     ],
     "static_attributes": [
       { "name":"refStore", "type": "Relationship", "value": "urn:ngsi-ld:Streetlight:streetlight:002"}
     ]
   }
 ]
}
'

curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
 "devices": [
   {
     "device_id":   "motion003",
     "entity_name": "urn:ngsi-ld:Motion:003",
     "entity_type": "Motion",
     "timezone":    "Europe/Berlin",
     "attributes": [
       { "object_id": "c", "name": "count", "type": "Integer" }
     ],
     "static_attributes": [
       { "name":"refStore", "type": "Relationship", "value": "urn:ngsi-ld:Streetlight:streetlight:003"}
     ]
   }
 ]
}
'
curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
 "devices": [
   {
     "device_id":   "motion004",
     "entity_name": "urn:ngsi-ld:Motion:004",
     "entity_type": "Motion",
     "timezone":    "Europe/Berlin",
     "attributes": [
       { "object_id": "c", "name": "count", "type": "Integer" }
     ],
     "static_attributes": [
       { "name":"refStore", "type": "Relationship", "value": "urn:ngsi-ld:Streetlight:streetlight:004"}
     ]
   }
 ]
}
'

curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
  "devices": [
    {
      "device_id": "lamp001",
      "entity_name": "urn:ngsi-ld:Lamp:001",
      "entity_type": "Lamp",
      "protocol": "PDI-IoTA-UltraLight",
      "transport": "HTTP",
      "endpoint": "http://iot-sensors:3001/iot/lamp001",
      "commands": [
        {"name": "on","type": "command"},
        {"name": "off","type": "command"}
       ],
       "attributes": [
        {"object_id": "s", "name": "state", "type":"Text"},
        {"object_id": "l", "name": "luminosity", "type":"Integer"}
       ],
       "static_attributes": [
         {"name":"refStore", "type": "Relationship","value": "urn:ngsi-ld:Streetlight:streetlight:001"}
      ]
    }
  ]
}
'

curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
  "devices": [
    {
      "device_id": "lamp002",
      "entity_name": "urn:ngsi-ld:Lamp:002",
      "entity_type": "Lamp",
      "protocol": "PDI-IoTA-UltraLight",
      "transport": "HTTP",
      "endpoint": "http://iot-sensors:3001/iot/lamp002",
      "commands": [
        {"name": "on","type": "command"},
        {"name": "off","type": "command"}
       ],
       "attributes": [
        {"object_id": "s", "name": "state", "type":"Text"},
        {"object_id": "l", "name": "luminosity", "type":"Integer"}
       ],
       "static_attributes": [
         {"name":"refStore", "type": "Relationship","value": "urn:ngsi-ld:Streetlight:streetlight:002"}
      ]
    }
  ]
}
'

curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
  "devices": [
    {
      "device_id": "lamp003",
      "entity_name": "urn:ngsi-ld:Lamp:003",
      "entity_type": "Lamp",
      "protocol": "PDI-IoTA-UltraLight",
      "transport": "HTTP",
      "endpoint": "http://iot-sensors:3001/iot/lamp003",
      "commands": [
        {"name": "on","type": "command"},
        {"name": "off","type": "command"}
       ],
       "attributes": [
        {"object_id": "s", "name": "state", "type":"Text"},
        {"object_id": "l", "name": "luminosity", "type":"Integer"}
       ],
       "static_attributes": [
         {"name":"refStore", "type": "Relationship","value": "urn:ngsi-ld:Streetlight:streetlight:003"}
      ]
    }
  ]
}
'
curl -s -o /dev/null -X POST \
  'http://iot-agent:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -g -d '{
  "devices": [
    {
      "device_id": "lamp004",
      "entity_name": "urn:ngsi-ld:Lamp:004",
      "entity_type": "Lamp",
      "protocol": "PDI-IoTA-UltraLight",
      "transport": "HTTP",
      "endpoint": "http://iot-sensors:3001/iot/lamp004",
      "commands": [
        {"name": "on","type": "command"},
        {"name": "off","type": "command"}
       ],
       "attributes": [
        {"object_id": "s", "name": "state", "type":"Text"},
        {"object_id": "l", "name": "luminosity", "type":"Integer"}
       ],
       "static_attributes": [
         {"name":"refStore", "type": "Relationship","value": "urn:ngsi-ld:Streetlight:streetlight:004"}
      ]
    }
  ]
}
'

echo -e " \033[1;32mIOT Devices created successfully\033[0m"
