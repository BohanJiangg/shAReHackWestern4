"use strict";

// Testing Global Variable. REMOVE BEFORE PRODUCTION PHASE
var response_json = {};
var data_scan = {};

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

function statusChangeCallback(response){
    // Testing Line with Global Variable. Remove later
    // Just for testing response json keys/values
    response_json = response;
    if (response.status === "connected") {
        AWS.config.region = 'us-east-1';
        AWS.config.credentials = new AWS.CognitoIdentityCredentials({
            IdentityPoolId: 'us-east-1:456a4c88-7f96-4783-a82e-a97f2c9dc22a',
            Logins: {
            'graph.facebook.com': response.authResponse.accessToken
            }
        });
        var params = {
            TableName : 'share-mobilehub-1774715290-locations',
            // Key: { 'id': '0.385739-0.254811'}
            // FilterExpression: "#zvalue between :start_yr and :end_yr",
            // ExpressionAttributeNames: {
            //     "#zvalue": "z",
            // },
            // ExpressionAttributeValues: {
            //     ":start_yr": 0.04,
            //     ":end_yr": 0.31
            // }
        };
        var documentClient = new AWS.DynamoDB.DocumentClient();

        documentClient.scan(params, function(err, data) {
            if (err) {
                console.log(err);
            } else {
                data_scan = data;
                console.log(data);
            }
        });
//   var dynamodb = new AWS.DynamoDB({apiVersion: '2012-08-10'});
//   var docClient = new AWS.DynamoDB.DocumentClient({service: dynamodb });
//   function scanData(docClient){
//     console.log(1);
//     var params = {
//        TableName: "share-mobilehub-1774715290-locations",
//        ProjectionExpression: "#zvalue, title, info.rating",
//        FilterExpression: "#zvalue between :start_yr and :end_yr",
//        ExpressionAttributeNames: {
//            "#zvalue": "z",
//        },
//        ExpressionAttributeValues: {
//            ":start_yr": 0.04,
//            ":end_yr": 0.31
//        }
//    };
//
//    docClient.scan(params, onScan);
//
//    function onScan(err, data) {
//      if (err){
//        console.log("You just made a big mistake!");
//      } else {
//        console.log(data);
//        data_scan = data;
//      }
//    }
//   scanData(docClient);
//   // If not Authorized, redirect to index and avoid
//   //location.replace("index.html");
// }
  }
}

  // Function to check login state - when I wake up, implement on document Load
  // So redirect if not logged, ie. don't let them get to Dashboard if they're not
  // Authorized
  function checkLoginState() {
    // Get the login response from the page
    FB.getLoginStatus(function(response) {
      // Call the statusChangeCallback function
      statusChangeCallback(response);
    });
  }

  // Load the SDK Asynchronously
  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "https://connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));