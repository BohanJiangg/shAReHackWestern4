"use strict";

/**
 * Callback upon retriving login status
 * @param {Object} response 
 */
function statusChangeCallback(response){
    if (response.status === "connected") {
        console.log(response)
        connectToCognito(response.authResponse.accessToken)
        var documentClient = new AWS.DynamoDB.DocumentClient();
    }
}

function retrieveDBData(documentClient) {
    var params = {
        TableName : 'share-mobilehub-1774715290-locations',
    };

    documentClient.scan(params, function(err, data) {
        if (err) {
            console.log(err);
        } else {
            data_scan = data;
            console.log(data);
        }
    });
}

