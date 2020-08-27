const axios = require('axios');
const fs = require('fs');
var sleep = require('system-sleep');
var NGSI_V2_STS = [];

axios.get('http://orion:1026/ngsi-ld/v1/entities?type=Streetlight&options=keyValues')
    .then(response => {
        //console.log(response.data);
                const data = response.data;
                for (var i in data){
                        NGSI_V2_STS.push({"href": "app/store/"+data[i].id , "name": (data[i].id).split(":").reverse()[1] + " " + (data[i].id).split(":").reverse()[0]})
                }
        fs.writeFile('response.json1', JSON.stringify(NGSI_V2_STS), function (err) {
            //console.log(err);
        });
	//console.log(NGSI_V2_STS);
    })
    .catch(err => {
        console.log(err)
    });

//sleep(10*1000);
//const NGSI_LD_STORES = JSON.parse(fs.readFileSync('response1.json'));

//console.log(NGSI_LD_STORES);

