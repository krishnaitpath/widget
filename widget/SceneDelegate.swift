//
//  SceneDelegate.swift
//  widget
//
//  Created by IPS-169 on 28/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // List of known shortcut actions.
    enum ActionType: String {
        case searchAction = "SearchAction"
        case shareAction = "ShareAction"
        case favoriteAction = "FavoriteAction"
        case testAction = "TestAction"
        case defaultAction = "DefaultAction"
    }
    
    static let favoriteIdentifierInfoKey = "FavoriteIdentifier"
    
    var window: UIWindow?
    var savedShortCutItem: UIApplicationShortcutItem!
    
    /// - Tag: willConnectTo
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /** Process the quick action if the user selected one to launch the app.
            Grab a reference to the shortcutItem to use in the scene.
        */
        guard let _: UIWindowScene = scene as? UIWindowScene else { return }
        maybeOpenedFromWidget(urlContexts: connectionOptions.urlContexts)
        if let shortcutItem = connectionOptions.shortcutItem {
            // Save it off for later when we become active.
            savedShortCutItem = shortcutItem
        }
    }
    
   

    // App opened from background
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("from widget")
      //  maybeOpenedFromWidget(urlContexts: URLContexts)
       guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(frame: UIScreen.main.bounds)
            
            if let item = URLContexts.first {
                let url = item.url

                if "\(url)" == "scheme://camera" {
                    let vc = ViewController()
                    let navController = UINavigationController(rootViewController: vc)
                    
                    window?.rootViewController = navController
                    window?.makeKeyAndVisible()
                    window?.windowScene = windowScene
                    
            let cameraController = CamaraViewController()
            let camNavController = UINavigationController(rootViewController: cameraController)
                    navController.present(camNavController, animated: true, completion: nil)
                }
            }
    }

    private func maybeOpenedFromWidget(urlContexts: Set<UIOpenURLContext>) {
        guard let _: UIOpenURLContext = urlContexts.first(where: { $0.url.scheme == "widget-deeplink" }) else { return }
        print("🚀 Launched from widget")
    }

    // MARK: - Application Shortcut Support
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Quick Action", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        /** In this sample an alert is being shown to indicate that the action has been triggered,
            but in real code the functionality for the quick action would be triggered.
        */
        if let actionTypeValue = ActionType(rawValue: shortcutItem.type) {
            switch actionTypeValue {
            case .searchAction:
                showAlert(message: "Search triggered")
            case .shareAction:
                showAlert(message: "Share triggered")
            case .testAction:
                showAlert(message: "Test triggered")
            case .favoriteAction:
                // Go to that particular favorite shortcut.
                showAlert(message: "Favourite Contact")
            case .defaultAction:
                showAlert(message: "Default action")
//                if let favoriteIdentifier = shortcutItem.userInfo?[SceneDelegate.favoriteIdentifierInfoKey] as? String {
//                    // Find the favorite contact from the userInfo identifier.
//
////                    if let foundFavoriteContact = ContactsData.shared.contact(favoriteIdentifier) {
////                        // Go to that favorite contact.
////                        if let navController = window?.rootViewController as? UINavigationController {
////                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
////                            if let contactsDetailViewController =
////                                storyboard.instantiateViewController(identifier: "ContactDetailViewController") as? ContactDetailViewController {
////                                // Pass the contact to the detail view controller and push it.
////                                contactsDetailViewController.contact = foundFavoriteContact
////                                navController.pushViewController(contactsDetailViewController, animated: false)
////                            }
////                        }
////                    }
//                }
            }
        }
        return true
    }
        
    /** Called when the user activates your application by selecting a shortcut on the Home Screen,
        and the window scene is already connected.
    */
    /// - Tag: PerformAction
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        print("Peform action for shortcut")
        let handled = handleShortCutItem(shortcutItem: shortcutItem)
        completionHandler(handled)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if savedShortCutItem != nil {
            _ = handleShortCutItem(shortcutItem: savedShortCutItem)
        }
    }
    
    /// - Tag: SceneWillResignActive
    func sceneWillResignActive(_ scene: UIScene) {
        // Transform each favorite contact into a UIApplicationShortcutItem.
        let application = UIApplication.shared
        /*application.shortcutItems = ContactsData.shared.favoriteContacts.map { contact -> UIApplicationShortcutItem in
            return UIApplicationShortcutItem(type: ActionType.favoriteAction.rawValue,
                                             localizedTitle: contact.name,
                                             localizedSubtitle: contact.email,
                                             icon: UIApplicationShortcutIcon(systemImageName: "star.fill"),
                                             userInfo: contact.quickActionUserInfo)
        }*/
    }
}

