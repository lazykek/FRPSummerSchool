//
//  SceneDelegate.swift
//  FRPSummerSchool
//
//  Created by Ilia Cherkasov on 16.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else {
      return
    }
    let rootViewController = UINavigationController(
      rootViewController: ViewController()
    )
    window = UIWindow(windowScene: scene)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
  }
}

