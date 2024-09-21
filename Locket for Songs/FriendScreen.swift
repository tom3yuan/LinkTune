//
//  FriendScreen.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/21/24.
//
struct User {
    let username: String
    }

import UIKit
import Firebase
import FirebaseFirestore

class FriendScreen: UIViewController {
    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let db = Firestore.firestore()
    var users: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsernames()
        // Do any additional setup after loading the view.
    }
    func fetchUsernames() {
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.users = [] // Reset users array
                for document in querySnapshot!.documents {
                    if let username = document.data()["username"] as? String {
                        self.users.append(User(username: username))
                    }
                }
                self.updateUI() // Call function to update UI
            }
        }
    }
    func updateUI() {
            friendTable.reloadData()
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
extension FriendScreen: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count // Return the number of users
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username // Set the cell's text to the username
        return cell
    }
}
