//
//  ViewController.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/20/24.
//

import UIKit
import FirebaseCore
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        class AppDelegate: UIResponder, UIApplicationDelegate {

          var window: UIWindow?

          func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions:
                           [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
              
            let db = Firestore.firestore()
              let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
              db.collection("users").document("userID").setData([
                  "name": storedUsername,
              ]) { err in
                  if let err = err {
                      print("Error writing document: \(err)")
                  } else {
                      print("Document successfully written!")
                  }
              }
            return true
          }
        }
        // Do any additional setup after loading the view.
    }


//    @IBAction func startButton(_ sender: Any) {
//    }
}

