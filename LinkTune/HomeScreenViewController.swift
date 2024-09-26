import UIKit
import Firebase
import FirebaseFirestore

struct User {
    let username: String
}

class HomeScreenViewController: UIViewController {
    @IBOutlet weak var refreshButton: UIButton!
//    @IBOutlet weak var titleLabel: UILabel!
    let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
    
    var friendsList: [String] = []  // Initialize as an empty array
    let db = Firestore.firestore()
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBAction func refresh(_ sender: Any) {
        getFriendListFromFirestore(forUsername: storedUsername) { [weak self] friendList in
            if let unwrappedFriends = friendList {
                self?.friendsList = unwrappedFriends  // Store the returned array in the variable
                
                // Call to get song lists after we have the friendsList
                self?.fetchSongs()
            } else {
                print("No friends found or an error occurred.")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeScreen loaded")
        
        view.addSubview(stackView)
        
        getFriendListFromFirestore(forUsername: storedUsername) { [weak self] friendList in
            if let unwrappedFriends = friendList {
                self?.friendsList = unwrappedFriends  // Store the returned array in the variable
                
                // Call to get song lists after we have the friendsList
                self?.fetchSongs()
            } else {
                print("No friends found or an error occurred.")
            }
        }
    }
    
    func fetchSongs() {
        clearStackView()
        var songs: [String] = []
        let totalFriends = friendsList.count
        var fetchedSongsCount = 0

        if totalFriends == 0 {
            // No friends to fetch songs for
//            titleLabel.text = "Add your friends first!"
            print("YOU HAVE NO FRIENDS")
            return
        }else{
//            titleLabel.text=""
        }

        for friend in friendsList {
            getSongListFromFirestore(forUsername: friend) { songList in
                if let songList = songList, !songList.isEmpty {
                    // Append the first song to the songs array
                    songs.append(songList[0])
                    
                    let songLabel = UILabel()
                    songLabel.text = songList[songList.count - 1]
                    songLabel.textAlignment = .left
                    songLabel.textColor = .white
                    self.stackView.addArrangedSubview(songLabel)
                    self.stackView.alignment = .center // Center the label horizontally
                    self.stackView.distribution = .equalSpacing
                }
                
                // Increment the fetchedSongsCount
                fetchedSongsCount += 1
                
                // After fetching songs for all friends, update the label
//                if fetchedSongsCount == totalFriends { // Check if this is the last friend
//                    let songListString = songs.joined(separator: ", ")
//                    print("Songs: \(songListString)")
//                    self.titleLabel.text = "Songs: \(songListString)"
//                }
            }
        }
        func clearStackView() {

                    // Remove all arranged subviews from the stack view

                    for arrangedSubview in stackView.arrangedSubviews {

                        stackView.removeArrangedSubview(arrangedSubview)

                        arrangedSubview.removeFromSuperview() // Remove it from the superview as well

                    }

                }
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
                    // Retrieve the "friendList" field
                    if let friendList = document.get("friendList") as? [String] {
                        print("Successfully fetched friendList: \(friendList)")
                        completion(friendList)  // Return the friend list
                    } else {
                        print("No friendList found for user \(username)")
                        completion(nil)  // Return nil if no friendList is found
                    }
                }
            } else {
                print("No document found for user \(username)")
                completion(nil)  // Return nil if no document found
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
}
