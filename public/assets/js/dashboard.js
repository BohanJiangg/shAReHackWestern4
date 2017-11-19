"use strict";

/**
 * Callback upon retriving login status
 * @param {Object} response 
 */
function statusChangeCallback(response){
    if (response.status === "connected") {
        connectToCognito(response.authResponse.accessToken)
        var documentClient = new AWS.DynamoDB.DocumentClient();
        retrieveDBData(documentClient);
    }
}

function retrieveDBData(documentClient) {
    var params = {
        TableName : 'share-fakedata',
    };
    console.log(documentClient)
    documentClient.scan(params, function(err, data) {
        if (err) {
            console.log(err);
        } else {
            console.log(data);
        }
    });
}

