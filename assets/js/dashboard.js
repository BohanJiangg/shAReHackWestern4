"use strict";

/**
 * On-click callback for facebook login button
 */
function checkLoginState() {
    // Get the login response from the page
    FB.getLoginStatus(function(response) {
        // Call the statusChangeCallback function
        statusChangeCallback(response);
    });
}

/**
 * Callback upon retriving login status
 * @param {Object} response 
 */
function statusChangeCallback(response){
    response_json = response;
    if (response.status === "connected") {
        AWS.config.region = 'us-east-1';
        AWS.config.credentials = new AWS.CognitoIdentityCredentials({
            IdentityPoolId: 'us-east-1:456a4c88-7f96-4783-a82e-a97f2c9dc22a',
            Logins: {
                'graph.facebook.com': response.authResponse.accessToken
            }
        });
        
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

