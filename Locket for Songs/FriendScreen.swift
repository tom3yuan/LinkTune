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


class FriendScreen: UIViewController {
    let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
    @IBOutlet weak var textbox1: UITextField!
    @IBOutlet weak var textbox2: UILabel!
    @IBOutlet weak var buton1: UIButton!
    var allNames: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllNames()
    }
    
    @IBAction func butonPresed(_ sender: Any) {
        var abc = textbox1.text
        if allNames.contains(abc!){
            updateFriendListByName(storedUsername, newFriend: abc!)
        }
        textbox1.text=""
        textbox2.text=abc! + " is now your friend!"
    }
    func fetchAllNames() {
        fetchAllNamesFromFirestore { [weak self] names, error in
            if let error = error {
                print("Error fetching names: \(error.localizedDescription)")
            } else if let names = names {
                self?.allNames = names  // Store fetched names in the array
                print("Fetched names: \(self?.allNames ?? [])")
            }
        }
    }
    
    func fetchAllNamesFromFirestore(completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        var names: [String] = []
        
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)  // Return nil and the error if fetching fails
            } else {
                for document in querySnapshot!.documents {
                    if let name = document.get("name") as? String {
                        names.append(name)  // Append the name to the array
                    }
                }
                completion(names, nil)  // Return the names array
            }
        }
    }
    func updateFriendListByName(_ name: String, newFriend: String) {
        let db = Firestore.firestore()
        // Query the "users" collection to find the document where the "name" field matches the provided name
        db.collection("users").whereField("name", isEqualTo: name).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
            } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                // If a document with the given name exists, get the first document
                if let document = querySnapshot.documents.first {
                    let documentID = document.documentID  // Get the document ID of the matched document
                    
                    // Update the "songList" field in the found document
                    db.collection("users").document(documentID).updateData([
                        "friendList": FieldValue.arrayUnion([newFriend])  // Add the new song to the songList
                    ]) { error in
                        if let error = error {
                            print("Error updating songList: \(error.localizedDescription)")
                        } else {
                            print("Successfully updated friendList for user \(name)")
                        }
                    }
                }
            } else {
                print("No document found with the name \(name)")
            }
        }
    }
    
}
