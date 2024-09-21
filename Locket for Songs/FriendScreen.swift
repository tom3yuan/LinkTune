//
//  FriendScreen.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/21/24.
//
//
//  FriendScreen.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/21/24.
//

import UIKit
import Firebase
import FirebaseFirestore

struct User {
    let username: String
}

class FriendScreen: UIViewController {
    @IBOutlet weak var friendTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var users: [User] = []
    var filteredUsers: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("FriendScreen loaded")
        
        // Set delegates
        searchBar.delegate = self
        friendTable.delegate = self
        friendTable.dataSource = self
        
        fetchUsernames()
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
                self.filteredUsers = self.users // Initialize filteredUsers with all users
                self.updateUI() // Call function to update UI
            }
        }
    }

    func updateUI() {
        friendTable.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FriendScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count // Return the number of filtered users
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = filteredUsers[indexPath.row]
        cell.textLabel?.text = user.username // Set the cell's text to the username
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension FriendScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all users
            filteredUsers = users
        } else {
            // Filter users based on the search text
            filteredUsers = users.filter { $0.username.localizedCaseInsensitiveContains(searchText) }
        }
        updateUI() // Update the UI to show the filtered results
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
}

// MARK: - UITableViewDelegate

extension FriendScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = filteredUsers[indexPath.row]
        print("Selected user: \(selectedUser.username)")
        // Implement any action when a user is selected
    }
}
