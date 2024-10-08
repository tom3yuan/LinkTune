//
//  ProfileScreen.swift
//  Locket for Songs
//
//  Created by Tom Yuan on 9/21/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameBox: UITextView!

    @IBOutlet weak var songsList: UIStackView!
    @IBOutlet weak var stackOfLists: UIStackView!
    @IBOutlet weak var friendsList: UIStackView!
    let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
        profileImage.clipsToBounds = true
        let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
        nameBox.text = storedUsername
        
        getSongListFromFirestore(forUsername: storedUsername) { songList in
                if let songList = songList {
                    for song in songList{
                        let songLabel = UILabel()
                        songLabel.text = song
                        songLabel.textAlignment = .center
                        songLabel.textColor = .black
                        self.songsList.addArrangedSubview(songLabel)
                        self.songsList.alignment = .center // Center the label horizontally
                        self.songsList.distribution = .equalSpacing
                    }
                }
            }
        
        getFriendListFromFirestore(forUsername: storedUsername) { friendList in
                if let friendList = friendList {
                    for friend in friendList{
                        let friendLabel = UILabel()
                        friendLabel.text = friend
                        friendLabel.textAlignment = .center
                        friendLabel.textColor = .black
                        self.friendsList.addArrangedSubview(friendLabel)
                        self.friendsList.alignment = .center // Center the label horizontally
                        self.friendsList.distribution = .equalSpacing
                    }
                }
            }
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(red: 30, green: 230, blue: 230, alpha: 50)
        
        profileImage.isUserInteractionEnabled = true
                
                // Create a UITapGestureRecognizer instance
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                
                // Add the gesture recognizer to the imageView
                profileImage.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func imageTapped() {
            print("Image was tapped!")
            // Add any additional logic here (e.g., navigate to a new screen, show alert, etc.)
            let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                
                // Present the image picker
                present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Access the selected image
            if let selectedImage = info[.editedImage] as? UIImage {
                profileImage.image = selectedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                profileImage.image = originalImage
            }
            
            // Dismiss the picker
            dismiss(animated: true, completion: nil)
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
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
                    if let songList = document.get("songList") as?
                        [String] {
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
    func getFriendListFromFirestore(forUsername username: String, completion: @escaping ([String]?) -> Void) {
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
                    if let friendList = document.get("friendList") as? [String] {
                        print("Successfully fetched friendList: \(friendList)")
                        completion(friendList)  // Return the song list
                    } else {
                        print("No friendList found for user \(username)")
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
