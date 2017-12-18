
//  AppDelegate.swift
//  HouseKeeping
//
//  Created by Apple-1 on 5/30/17.
//  Copyright © 2017 Apple-1. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import FirebaseAuth
import LIHAlert

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.setMinimumBackgroundFetchInterval(
            UIApplicationBackgroundFetchIntervalMinimum)
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {(granted, error) in
                    print("is granted " , granted)
            })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        //application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationCenter.default.addObserver(self,selector: #selector(tokenRefreshNotification(notification:)),name: NSNotification.Name.InstanceIDTokenRefresh,object: nil)
        registerForPushNotifications()
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        print("--->didRefreshRegistrationToken:\(fcmToken)")
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //handle notification here
        completionHandler([.alert, .badge, .sound])
        print("Foreground came")
        //let content = UNMutableNotificationContent()
        //content.sound = UNNotificationSound.default()
    }
    
    var textWithButtonAlert: LIHAlert?
    
    @available(iOS 10.0, *)
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        // Convert to pretty-print JSON, just to show the message for testing
        //print("--->didReceive Remote Message:\(remoteMessage.appData)")
        guard let data =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else {
                return
        }
        print("Received direct channel message:\n\(prettyPrinted)")
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Called to let your app know which action was selected by the user for a given notification.
        let userInfo = response.notification.request.content.userInfo as? NSDictionary
        print("CLICKED")
        print("\(userInfo)")
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().setAPNSToken(deviceToken as Data, type: InstanceIDAPNSTokenType.sandbox)
        
        //let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //print("deviceTokenString  ", deviceTokenString)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = InstanceID.instanceID().token()
        print("****** tokenRefreshNotification ***** ",refreshedToken!)
        //print(refreshedToken!)
        let defaults = UserDefaults.standard
        defaults.set(refreshedToken!, forKey: "NotificationToken")
        connectToFcm()
    }
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    private func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification: \(userInfo)")
        //let content = UNMutableNotificationContent()
        //content.sound = UNNotificationSound.default()
        completionHandler(.newData)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the back    ground state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        let defaults = UserDefaults.standard
//        let TIMERR = defaults.string(forKey: "TIMER")
//        print("TIMERR  at shutdown" , TIMERR!)
//        let checkFunc = currentTask()
//        checkFunc.viewDidLoad()
//        if TIMERR == "Timerstarted" {
//            let defaults = UserDefaults.standard
//            let notificationToken = defaults.string(forKey: "NotificationToken")
//            let runText = currentTask()
//            let RUNTest = runText.TimerLbl.text
//            print("TimerAtClose  ", RUNTest!)
//            defaults.set(RUNTest!, forKey: "TimerAtClose")
//            let params = [
//                "to" : notificationToken!,
//                "notification": [
//                    "body": "Admin has assigned a new task to you ! (App Terminted) ",
//                    "title": "New Assigned Task \(RUNTest)",
//                    "icon" : "appicon"
//                ]
//                ] as [String : Any]
//            
//            Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Authorization": "key=AAAAyjwdNyA:APA91bGV2vuj8jt2IyTjlVFbW8bIVz30I7y7qPFvmGaQKXx4yXHpwXUIb3_bCWeMFjq7LPNxgq5lIMuiVyVWRNtdbOs7NKf91puJCqZyyvjjBgbv0MMX8_allj_SC8dsC_d40Z01sgwG"]).responseJSON {
//                response in
//                switch response.result {
//                case .success(_):
//                    break
//                case .failure(_):
//                    break
//                }
//            }
//    }
    self.saveContext()
}

// MARK: - Core Data stack

lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "HouseKeeping")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// MARK: - Core Data Saving support

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

}

