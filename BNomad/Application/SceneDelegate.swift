//
//  SceneDelegate.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/13.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
//    lazy var viewModel: CombineViewModel = CombineViewModel.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        _ = RCValue.shared
        let deviceUid = UIDevice.current.identifierForVendor?.uuidString
        guard let deviceUid = deviceUid else { return }
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = ReviewListViewController()
        window?.makeKeyAndVisible()

//        FirebaseManager.shared.checkUserExist(userUid : deviceUid) { isExist in
//            if isExist {
//                FirebaseManager.shared.fetchUser(id: deviceUid) { user in
//                    self.viewModel.user = user
//                    FirebaseManager.shared.fetchCheckInHistory(userUid: deviceUid) { checkInHistory in
//                        self.viewModel.user?.checkInHistory = checkInHistory
//                        print("checkIn 유무", self.viewModel.user?.isChecked)
//                        self.window?.rootViewController = UINavigationController(rootViewController: MapViewController())
//                        self.window?.makeKeyAndVisible()
//                    }
//                }
//            } else {
//                print("no user")
//                self.window?.rootViewController = UINavigationController(rootViewController: MapViewController())
//                self.window?.makeKeyAndVisible()
//            }
//        }
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

