# shARe

shARe is a Social Media AR App that allows the user to post text messages in AR, using the real-time GeoLocation of the user. This allows people around the user to see these AR messages in real time, and enables an entirely new type of social media communication revolving around real-life objects, landmarks, and interesting remarks around a user's current physical location. As this app is integrated with the facebook login API, this AR App could be used as a social network to connect various people to each other, and allows for either anonymous posting or the posting to be seen by selected friend groups. 

# How we built it

The front-end portion of the App was built using Swift, XCode, and the the ARKit SDK. The back-end was connected to Amazon Web Services' DynamoDB that serves as the database. The web application is made using HTML, CSS, and JavaScript with Google Maps API and the Facebook Login API, all hosted on Firebase. The Facebook Login API is used for user identification and authentication of the user such as to allow the user to see the relevant points marked around him. The Google Maps API is used in the web app to reveal to the user the geolocation and message contents of the markers around him.
