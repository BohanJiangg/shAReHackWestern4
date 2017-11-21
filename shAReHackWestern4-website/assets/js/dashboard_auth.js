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
 * Amazon Cognito configuration
 */
function connectToCognito(accessToken) {
    AWS.config.region = 'us-east-1';
    AWS.config.update({
        credentials: new AWS.CognitoIdentityCredentials({
            IdentityPoolId: 'us-east-1:456a4c88-7f96-4783-a82e-a97f2c9dc22a',
            Logins: {
                'graph.facebook.com': accessToken
            }
        })
    })
}