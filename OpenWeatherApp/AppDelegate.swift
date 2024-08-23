//
//  AppDelegate.swift
//  OpenWeatherApp
//
//  Created by Sailor on 8/23/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: searchViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
