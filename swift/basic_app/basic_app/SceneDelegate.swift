//
//  SceneDelegate.swift
//  basic_app
//
//  Created by Liaz Kamper on 11/05/2020.
//  Copyright © 2020 OneLink. All rights reserved.
//

import UIKit
import AppsFlyerLib

import BranchSDK


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        NSLog("[AFSDK] 1. %@", "scene with Universal Link")
        // Universal Link - Background -> foreground
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        
        BranchScene.shared().scene(scene, continue: userActivity)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // Background -> foreground
        NSLog("[AFSDK] 2. %@", "scene with URI scheme")
        if let url = URLContexts.first?.url {
            AppsFlyerLib.shared().handleOpen(url, options: nil)
        }
        
        BranchScene.shared().scene(scene, openURLContexts: URLContexts)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NSLog("[AFSDK] 3. %@", "Deep Linking from killed state")
        
        // URI scheme - killed -> foreground
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

//        // Processing Universal Link from the killed state
        if let userActivity = connectionOptions.userActivities.first {
            NSLog("[AFSDK] 4. Processing Universal Link from the killed state")
            AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
            
            BranchScene.shared().scene(scene, continue: userActivity)
            
            
        } else if let url = connectionOptions.urlContexts.first?.url {
            NSLog("[AFSDK] 5. Processing URI scheme from the killed state")
            AppsFlyerLib.shared().handleOpen(url, options: nil)
            
            BranchScene.shared().scene(scene, openURLContexts: connectionOptions.urlContexts)
        }
//      // Processing URI-scheme from the killed state
//      self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        guard let _ = (scene as? UIWindowScene) else { return }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

