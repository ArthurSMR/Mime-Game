//
//  SceneDelegate.swift
//  Mime Game
//
//  Created by Arthur Rodrigues on 08/04/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //LINK: mime://invite-mime-game?appID=973c32ecfb4e497a9024240f3126d67f&roomName=Sala-1
        
        for urlContext in connectionOptions.urlContexts {
            let url = urlContext.url

            guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }

            let host = urlComponents.host

            if host == "invite-mime-game" {
                DeepLink.shared.appID = url.getQueryStringParameter(url: url.absoluteString, param: "appID") ?? ""
                DeepLink.shared.roomName = url.getQueryStringParameter(url: url.absoluteString, param: "roomName") ?? ""
                
                if DeepLink.shared.appID.isEmpty && DeepLink.shared.roomName.isEmpty {
                    DeepLink.shared.shouldNavigateToLobby = false
                } else {
                    DeepLink.shared.shouldNavigateToLobby = true
                }
            }
        }
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

