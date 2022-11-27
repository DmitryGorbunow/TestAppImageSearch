//
//  SceneDelegate.swift
//  TestApp (Image Search)
//
//  Created by Dmitry Gorbunow on 11/21/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        window?.makeKeyAndVisible()
        let controller = SearchController()
        let navController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navController
    }

   
}

