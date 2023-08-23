#!/bin/bash
#Script to create an app that utilises the shared objects created from the previous script.

# Get username/password from a file
cred=`cat ../PW.txt`;user=`echo $cred | cut -d':' -f1`;pw=`echo $cred | cut -d':' -f2`
curl -s -X POST -u admin:$pw -H "Content-Type: application/json" -d \
'
{
    "class": "ADC",
    "updateMode": "selective",
    "schemaVersion": "3.46.0",
    "id": "declarationId",
    "label": "theDeclaration",
    "remark": "All properties declaration",
    "constants": {
        "class": "Constants",
        "timestamp": "2018-12-10T19:23:45Z",
        "newConstant": 100
    },
    "Common": {
        "class": "Tenant",
        "label": "commonTenant",
        "remark": "Declaration Common tenant",
        "enable": true,
        "Shared": {
            "class": "Application",
            "template": "shared",
            "enable": true
        },
        "constants": {
            "class": "Constants",
            "someConstant": "A new constant"
        },
        "controls": {
            "class": "Controls",
            "logLevel": "error",
            "trace": true,
            "fortune": false
        }
    },
    "controls": {
        "class": "Controls",
        "logLevel": "error",
        "trace": true,
        "archiveId": "",
        "archiveTimestamp": "2018-12-10T19:23:45Z"
    },
    "SHQ_02": {
        "class": "Tenant",
        "A1": {
            "class": "Application",
            "VS1": {
                "class": "Service_UDP",
                "protocol": "udp",
                "virtualPort":  {"bigip": "/Common/Shared/test.port.list"} ,
                "virtualAddresses": [
                    "10.1.1.13"
                ],
                "pool": {"bigip": "/Common/Shared/poolRoundRobin"}
            }
        }
    }
}' \
-k "https://$1/mgmt/shared/appsvcs/declare" |jq

