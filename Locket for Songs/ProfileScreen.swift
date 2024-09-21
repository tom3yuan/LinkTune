//
//  ProfileScreen.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/21/24.
//

import UIKit

class ProfileScreen: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
        nameBox.text = storedUsername
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(red: 30, green: 230, blue: 230, alpha: 50)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
