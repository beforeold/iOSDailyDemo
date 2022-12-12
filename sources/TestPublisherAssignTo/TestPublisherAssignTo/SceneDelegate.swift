//
//  SceneDelegate.swift
//  TestPublisherAssignTo
//
//  Created by beforeold on 2022/12/12.
//

import UIKit

import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  
  var age = 5 {
    didSet {
      print("did set \(age)")
    }
  }

  let publisher = PassthroughSubject<Int, Never>()
  
  class UnownedBox<T: AnyObject> {
    weak var value: T!
    
    init(_ value: T) {
      self.value = value
    }
  }
  
  
  var bag: [AnyCancellable] = []
  
  fileprivate func subscribe() {
    /*
    publisher
      .assign(to: \.age, on: self)
      .store(in: &bag)
    */
    
    publisher
      .assign(to: \.value.age,
              on: UnownedBox(self))
      .store(in: &bag)
    
    publisher.send(15)
    publisher.send(20)
  }

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let _ = (scene as? UIWindowScene) else { return }
    
    subscribe()
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
    print("become active")
    
  }

  static var global = 10
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    
    Self.global += 5
    publisher.send(Self.global)
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

