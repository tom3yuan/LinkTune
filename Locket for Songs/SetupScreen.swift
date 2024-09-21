//
//  SetupScreen.swift
//  Locket for Songs
//
//  Created by Kevin Yuan on 9/21/24.
//

import UIKit

class SetupScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var usernameTextbox: UITextField!
    @IBOutlet weak var passwordTextbox: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBAction func createButton(_ sender: Any) {
            // Get text from the username and password textboxes
            let username = getUsername()
            let password = getPassword()
        
            UserDefaults.standard.set(username, forKey: "username")
            // CHECK IF USERNAME IS VALID
            //IF IT IS, USER IS TRYING TO LOG IN, IF NOT, USER IS TRYING TO REGISTER
        
            print("Username: \(username)")
            print("Password: \(password)")
            
            // You can add additional logic here to handle the data (e.g., validation, saving, etc.)
        }
        
        // Function to retrieve the username text
    func getUsername() -> String {
        return usernameTextbox.text ?? "" // Returns the entered username or an empty string if nil
    }
        
        // Function to retrieve the password text
    func getPassword() -> String {
        return passwordTextbox.text ?? "" // Returns the entered password or an empty string if nil
    }
    /*
     @IBOutlet weak var UsernameLabel: UILabel!
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
