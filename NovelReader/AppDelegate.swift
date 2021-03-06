//
//  AppDelegate.swift
//  NovelReader
//
//  Created by kang on 3/14/16.
//  Copyright © 2016 ruikyesoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions _: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        if !CODE_TEST {
            // Restore save reader style
            Typesetter.restore();
            
            self.window?.rootViewController = LaunchViewController(
                mainController: MenuViewController(nibName: "MenuViewController", bundle: nil)) { splash in
                    // Download font
                    splash.setProgressText("Querying \(Typesetter.Ins.font)")

                    FontManager.asyncDownloadFont(Typesetter.Ins.font) { state, font, progress in
                        if state == FontManager.State.Downloading {
                            splash.setProgressText("Downloading  \(Typesetter.Ins.font) \(progress)%")
                            splash.setProgressValue(progress / 100)
                        } else if state.completed {
                            splash.setProgressValue(1)
                            splash.displayMainController()
                            FontManager.tryToLoadAll()
                        } else {
                            splash.setProgressText("\(state) \(font)")
                        }
                    }
            }
        } else {
            self.window?.rootViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        }

        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data,
        // invalidate timers, and store enough application state information to restore your application to
        // its current state in case it is terminated later.
        // If your application supports background execution,
        // this method is called instead of applicationWillTerminate: when the user quits.
        Typesetter.Ins.save()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state;
        // here you can undo many of the changes made on entering the background.
        // Typesetter.restore()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
    }
}

