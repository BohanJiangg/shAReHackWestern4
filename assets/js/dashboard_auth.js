// Asynchronously iniitializes Facebook Integration
// App ID, API version, xfbml = true
window.fbAsyncInit = function() {
    FB.init({
        appId      : '291168591401232',
        xfbml      : true,
        version    : 'v2.11'
    });
    FB.AppEvents.logPageView();
};

// Load facebook SDK Asynchronously
function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "https://connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk');

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
    AWS.config.credentials = new AWS.CognitoIdentityCredentials({
        IdentityPoolId: 'us-east-1:456a4c88-7f96-4783-a82e-a97f2c9dc22a',
        Logins: {
            'graph.facebook.com': accessToken
        }
    });
}