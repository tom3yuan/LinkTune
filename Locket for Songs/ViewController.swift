//
//  ViewController.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/20/24.
//

import UIKit
import FirebaseCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        class AppDelegate: UIResponder, UIApplicationDelegate {

          var window: UIWindow?

          func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:
                           [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()

            return true
          }
        }
        // Do any additional setup after loading the view.
    }


//    @IBAction func startButton(_ sender: Any) {
//    }
}

