//
//  AppDelegate.swift


import UIKit
import CocoaLumberjack
import AWSAuthCore
import AWSCore
import AWSCognito
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS
import FacebookCore
import FBSDKLoginKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // set up the initialized flag
    var isInitialized = false

    var window: UIWindow?


    //added these 3 methods

    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // AWS setup
//        let didFinishLaunching = AWSSignInManager.sharedInstance().interceptApplication(
//            application, didFinishLaunchingWithOptions: launchOptions)
//
//        if (!isInitialized) {
//            AWSSignInManager.sharedInstance().resumeSession(completionHandler: {
//                (result: Any?, error: Error?) in
//                print("Result: \(result) \n Error:\(error)")
//            })
//            isInitialized = true
//        }
        
        // AWS Logging
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "us-east-1:456a4c88-7f96-4783-a82e-a97f2c9dc22a")
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration


        
        // Override point for customization after application launch.
    
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        DDLogDebug("NEW SESSION")
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window!.makeKeyAndVisible()
        
        
        if(AccessToken.current != nil){
            NSLog("Logged In")
        }
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        if #available(iOS 11.0, *) {
            if let accessToken = FBSDKAccessToken.current(){
                print(accessToken)
               self.window!.rootViewController =  ViewController()
            }else{
                print("Not logged In.")
                self.window!.rootViewController = loginViewController()
            }
            
        } else {
            self.window!.rootViewController = NotSupportedViewController() 
        }
        
        
        return true
         //return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

   /**func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }**/

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

