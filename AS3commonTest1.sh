#!/bin/bash
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
    "Common": {
        "class": "Tenant",
        "Shared": {
            "class": "Application",
            "template": "shared",
            "test.port.list": {
                "class": "Net_Port_List",
                "remark": "description",
                "ports": [
                    80,
                    443,
                    "8080-8088"
                ],
                "portLists": [
                    {
                        "use": "portList"
                    }
                ]
            },
            "portList": {
                "class": "Net_Port_List",
                "ports": [
                    "1-999"
                ]
            },
            "poolRoundRobin": {
                "class": "Pool",
                "loadBalancingMode": "round-robin",
                "monitors": [
                    "http"
                ],
                "members": [
                    {
                        "servicePort": 80,
                        "serverAddresses": [
                            "198.19.192.58",
                            "198.19.192.59",
                            "198.19.192.60"
                        ]
                    }
                ]
            }
        }
    }
}' \
-k "https://$1/mgmt/shared/appsvcs/declare" 

