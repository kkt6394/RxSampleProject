//
//  SceneDelegate.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/20/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        let vc1 = NumbersViewController()
        let vc2 = SimpleTableViewExampleViewController()
        let vc3 = SimpleValidationViewController()
        let vc4 = UINavigationController(rootViewController: HomeworkViewController())
        tabBarController.viewControllers = [vc1, vc2, vc3, vc4]
        
        vc1.tabBarItem = UITabBarItem(title: "Number", image: UIImage(systemName: "numbers"), tag: 0)
        vc2.tabBarItem = UITabBarItem(title: "TableView", image: UIImage(systemName: "tablecells"), tag: 1)
        vc3.tabBarItem = UITabBarItem(title: "Validation", image: UIImage(systemName: "circle.badge.checkmark"), tag: 2)
        vc4.tabBarItem = UITabBarItem(title: "Homework", image: UIImage(systemName: "fireworks"), tag: 3)

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

