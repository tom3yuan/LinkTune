//
//  ProfileScreen.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/21/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileScreen: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameBox: UITextView!

    @IBOutlet weak var listOfSongs: UITextView!
    let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
        nameBox.text = storedUsername
        getSongListFromFirestore(forUsername: storedUsername) { songList in
                if let songList = songList {
                    // Convert the array of song names into a single string
                    let songListString = songList.joined(separator: ", ")
                    // Set the label's text to the formatted string
                    self.listOfSongs.text = "Songs: \(songListString)"
                } else {
                    self.listOfSongs.text = "Could not retrieve song list."
                }
            }
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(red: 30, green: 230, blue: 230, alpha: 50)
    }
    
    
    func getSongListFromFirestore(forUsername username: String, completion: @escaping ([String]?) -> Void) {
        let db = Firestore.firestore()
        
        // Query the "users" collection for the document with the specified username
        db.collection("users").whereField("name", isEqualTo: username).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                completion(nil)  // Return nil on error
            } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                // Get the first matching document
                if let document = querySnapshot.documents.first {
                    // Retrieve the "songList" field
                    if let songList = document.get("songList") as? [String] {
                        print("Successfully fetched songList: \(songList)")
                        completion(songList)  // Return the song list
                    } else {
                        print("No songList found for user \(username)")
                        completion(nil)  // Return nil if no songList is found
                    }
                }
            } else {
                print("No document found for user \(username)")
                completion(nil)  // Return nil if no document found
            }
        }
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
