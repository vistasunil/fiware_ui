const NGSI_VERSION = process.env.NGSI_VERSION || 'ngsi-v2';

const express = require('express');
const router = express.Router();
const monitor = require('../lib/monitoring');
const Store = require('../controllers/' + NGSI_VERSION + '/store');
const History = require('../controllers/history');
const DeviceListener = require('../controllers/iot/command-listener');
const Security = require('../controllers/security');
const _ = require('lodash');

const TRANSPORT = process.env.DUMMY_DEVICES_TRANSPORT || 'HTTP';
const DEVICE_PAYLOAD = process.env.DUMMY_DEVICES_PAYLOAD || 'ultralight';
const GIT_COMMIT = process.env.GIT_COMMIT || 'unknown';
const SECURE_ENDPOINTS = process.env.SECURE_ENDPOINTS || false;
const OIDC_ENABLED = process.env.OIDC_ENABLED || false;
const AUTHZFORCE_ENABLED = process.env.AUTHZFORCE_ENABLED || false;

const NOTIFY_ATTRIBUTES = ['refStore', 'refProduct', 'refShelf', 'type', 'locatedIn', 'stocks'];

const axios = require('axios');
const fs = require('fs');
var sleep = require('system-sleep');
var NGSI_V2_STS = [];

axios.get('http://orion:1026/ngsi-ld/v1/entities?type=Streetlight&options=keyValues')
    .then(response => {
        //console.log(response.data);
		const data = response.data;
		for (var i in data){
			NGSI_V2_STS.push({href: data[i].id , name: (data[i].id).split(":").reverse()[1] + " " + (data[i].id).split(":").reverse()[0]})
		}
        fs.writeFile('response.json', JSON.stringify(NGSI_V2_STS), function (err) {
            //console.log(err);
        });
    })
    .catch(err => {
        console.log(err)
    });

sleep(10*1000);
const NGSI_LD_STORES = fs.readFileSync('response.json','utf8');

console.log(NGSI_LD_STORES);
const NGSI_V2_STORES = [
    {
        href: 'app/store/' + process.env.Streetlight1_urn, //'app/store/urn:ngsi-ld:Streetlight:streetlight:mexico:4567',
        name: process.env.Streetlight1_name //'Streetlight Mexico 4567'
    },
    {
        href: 'app/store/' + process.env.Streetlight2_urn, //'app/store/urn:ngsi-ld:Streetlight:streetlight:guadalajara:4567',
        name: process.env.Streetlight2_name //'Streetlight Guadalajara 4567'
    },
    {
        href: 'app/store/' + process.env.Streetlight3_urn, // 'app/store/urn:ngsi-ld:Streetlight:streetlight:mexico:5000',
        name: process.env.Streetlight3_name //'Streetlight Mexico 5000'
    },
    {
        href: 'app/store/' + process.env.Streetlight4_urn, //'app/store/urn:ngsi-ld:Streetlight:streetlight:mexico:9000',
        name: process.env.Streetlight4_name //'Streetlight Mexico 9000'
    }
];

/*const NGSI_LD_STORES = [
    {
        href: 'app/store/' + process.env.Streetlight1_urn, //'app/store/urn:ngsi-ld:Streetlight:streetlight:mexico:4567',
        name: process.env.Streetlight1_name //'Streetlight Mexico 4567'
    },
    {
        href: 'app/store/' + process.env.Streetlight2_urn, //'app/store/urn:ngsi-ld:Streetlight:streetlight:guadalajara:4567',
        name: process.env.Streetlight2_name //'Streetlight Guadalajara 4567'
    },
    {
        href: 'app/store/' + process.env.Streetlight3_urn, // 'app/store/urn:ngsi-ld:Streetlight:streetlight:mexico:5000',
        name: process.env.Streetlight3_name //'Streetlight Mexico 5000'
    },
    {
        href: 'app/store/' + process.env.Streetlight4_urn, //'app/store/urn:ngsi-ld:Streetlight:streetlight:mexico:9000',
        name: process.env.Streetlight4_name //'Streetlight Mexico 9000'
    }
];*/

// Error handler for async functions
function catchErrors(fn) {
    return (req, res, next) => {
        return fn(req, res, next).catch(next);
    };
}

// If an subscription is recieved emit socket io events
// using the attribute values from the data received to define
// who to send the event too.
function broadcastEvents(req, item, types) {
    const message = req.params.type + ' received';
    _.forEach(types, (type) => {
        if (item[type]) {
            monitor(item[type], message);
        }
    });
}

// Handles requests to the main page
router.get('/', function (req, res) {
    const securityEnabled = false ;//SECURE_ENDPOINTS;
    const oidcEnabled = OIDC_ENABLED;
    const stores = NGSI_VERSION === 'ngsi-v2' ? NGSI_V2_STORES : NGSI_LD_STORES;
    res.render('index', {
        success: req.flash('success'),
        errors: req.flash('error'),
        info: req.flash('info'),
        securityEnabled,
        oidcEnabled,
        stores,
        ngsi: NGSI_VERSION
    });
});

// Logs users in and out using Keyrock.
router.get('/login', Security.logInCallback);
router.get('/clientCredentials', Security.clientCredentialGrant);
router.get('/implicitGrant', Security.implicitGrant);
router.post('/userCredentials', Security.userCredentialGrant);
router.post('/refreshToken', Security.refreshTokenGrant);
router.get('/authCodeGrant', Security.authCodeGrant);
router.get('/hybrid', Security.hybrid);
router.get('/logout', Security.logOut);

// Open ID Connect
router.get('/authCodeOICGrant', Security.authCodeOICGrant);
router.get('/implicitOICGrant', Security.implicitOICGrant);
router.get('/hybridOICGrant', Security.hybridOICGrant);

router.get('/version', function (req, res) {
    res.setHeader('Content-Type', 'application/json');
    res.send({ gitHash: GIT_COMMIT });
});

// Render the monitoring page
router.get('/device/monitor', function (req, res) {
    const traffic = TRANSPORT === 'HTTP' ? 'Northbound Traffic' : 'MQTT Messages';
    const title = 'Streetlight Control Panel (' + DEVICE_PAYLOAD + ' over ' + TRANSPORT + ')';
    const securityEnabled = false ; //SECURE_ENDPOINTS;
    const oidcEnabled = OIDC_ENABLED;
    res.render('device-monitor', {
        title,
        traffic,
        securityEnabled,
        oidcEnabled
    });
});

// Access to IoT devices is secured by a Policy Decision Point (PDP).
// LEVEL 1: AUTHENTICATION ONLY -  For most actions, any user is authorized, just ensure the user exists.
// LEVEL 2: BASIC AUTHORIZATION -  Ringing the alarm bell and unlocking the Door are restricted to certain
//                                 users.
// LEVEL 3: XACML AUTHORIZATION -  Ringing the alarm bell and unlocking the Door are restricted via XACML
//                                 rules to certain users at certain times of day.
router.post('/device/command', DeviceListener.accessControl, DeviceListener.sendCommand);

// Retrieve Device History from STH-Comet
if (process.env.STH_COMET_SERVICE_URL) {
    router.get('/device/history/:deviceId', catchErrors(History.readCometDeviceHistory));
}
// Retrieve Device History from Crate-DB
if (process.env.CRATE_DB_SERVICE_URL) {
    router.get('/device/history/:deviceId', catchErrors(History.readCrateDeviceHistory));
}

// Display the app monitor page
router.get('/app/monitor', function (req, res) {
    res.render('monitor', { title: 'Event Monitor' });
});

// Display the app monitor page
router.get('/device/history', function (req, res) {
    const data = NGSI_VERSION === 'ngsi-v2' ? NGSI_V2_STORES : NGSI_LD_STORES;
    const stores = [];

    if (process.env.CRATE_DB_SERVICE_URL || process.env.STH_COMET_SERVICE_URL) {
        data.forEach((element) => {
            stores.push({
                name: element.name,
                href: element.href.replace('app/store/', 'history/')
            });
        });
    }
    res.render('history-index', {
        title: 'Short-Term History',
        stores
    });
});

// Viewing Store information is secured by Keyrock PDP.
// LEVEL 1: AUTHENTICATION ONLY - Users must be logged in to view the store page.
router.get('/app/store/:storeId', Security.authenticate, Store.displayStore);
// Display products for sale
router.get('/app/store/:storeId/till', Store.displayTillInfo);
// Render warehouse notifications
router.get('/app/store/:storeId/warehouse', Store.displayWarehouseInfo);
// Buy something.
router.post('/app/inventory/:inventoryId', catchErrors(Store.buyItem));

// Changing Prices is secured by a Policy Decision Point (PDP).
// LEVEL 2: BASIC AUTHORIZATION - Only managers may change prices - use Keyrock as a PDP
// LEVEL 3: XACML AUTHORIZATION - Only managers may change prices are restricted via XACML
//                                - use Authzforce as a PDP
router.get(
    '/app/price-change',
    function (req, res, next) {
        // Use Advanced Autorization if Authzforce is present.
        return AUTHZFORCE_ENABLED
            ? Security.authorizeAdvancedXACML(req, res, next)
            : Security.authorizeBasicPDP(req, res, next);
    },
    Store.priceChange
);
// Ordering Stock is secured by a Policy Decision Point (PDP).
// LEVEL 2: BASIC AUTHORIZATION - Only managers may order stock - use Keyrock as a PDP
// LEVEL 3: XACML AUTHORIZATION - Only managers may order stock are restricted via XACML
//                                - use Authzforce as a PDP
router.get(
    '/app/order-stock',
    function (req, res, next) {
        // Use Advanced Authorization if Authzforce is present.
        return AUTHZFORCE_ENABLED
            ? Security.authorizeAdvancedXACML(req, res, next)
            : Security.authorizeBasicPDP(req, res, next);
    },
    Store.orderStock
);

// Whenever a subscription is received, display it on the monitor
// and notify any interested parties using Socket.io
router.post('/subscription/:type', (req, res) => {
    monitor('notify', req.params.type + ' received', req.body);
    _.forEach(req.body.data, (item) => {
        broadcastEvents(req, item, NOTIFY_ATTRIBUTES);
    });
    res.status(204).send();
});

module.exports = router;
