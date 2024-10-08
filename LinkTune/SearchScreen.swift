import UIKit
import Firebase
import FirebaseFirestore

class SearchScreen: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var successMessage: UILabel!
    
    var allSongs: [[String : String]] = []
    var filteredSongs: [[String : String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Set up search bar and table view
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "songCell")

        
        // Initially, hide the table view
        tableView.alpha = 0
        
        // Load songs from dataset.csv
        loadSongs()
        
        // Show all songs initially
        filteredSongs = allSongs
        tableView.reloadData()
    }
    
    // MARK: - CSV Parsing
    
    func loadSongs() {
        // Get the path for the dataset.csv
        guard let csvPath = Bundle.main.path(forResource: "dataset", ofType: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            // Read the contents of the file
            let csvData = try String(contentsOfFile: csvPath)
            let rows = csvData.components(separatedBy: "\n")
            
            // Iterate over rows, skipping the header if any
            for row in rows.dropFirst() {
                let values = row.components(separatedBy: ",")
                
                if values.count >= 5 {
                    // Extract song data (track_name is at index 4 and artists at index 2)
                    let songName = values[4].trimmingCharacters(in: .whitespacesAndNewlines)
                    let artistName = values[2].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Check that both values are non-empty
                    if !songName.isEmpty && !artistName.isEmpty {
                        // Create a dictionary for each song entry
                        let songData: [String: String] = [
                            "songName": songName,
                            "artistName": artistName
                        ]
                        
                        // Append the song data to the allSongs array
                        allSongs.append(songData)
                    }
                }
            }
            
        } catch {
            print("Error reading CSV: \(error)")
        }
        
        print("All songs loaded: \(allSongs)")
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Show all songs if search text is empty
            filteredSongs = allSongs
        } else {
            // Filter songs based on the search text, matching either song name or artist name
            filteredSongs = allSongs.filter { song in
                let songName = song["songName"] ?? ""
                let artistName = song["artistName"] ?? ""
                return songName.localizedCaseInsensitiveContains(searchText) ||
                       artistName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Show the table view and reload data
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        //change!
        tableView.reloadData() // Reload the table view with filtered results
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        // Safely unwrap the song data for the current row
        let song = filteredSongs[indexPath.row]
        let songName = song["songName"] ?? "Unknown Song"
        let artistName = song["artistName"] ?? "Unknown Artist"
        
        // Display both song name and artist name
        cell.textLabel?.text = "\(songName) by \(artistName)"
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = filteredSongs[indexPath.row]
        if let songName = selectedSong["songName"], let artistName = selectedSong["artistName"] {
            print("Selected song: \(songName) by \(artistName)")
            let storedUsername = UserDefaults.standard.string(forKey: "username") ?? ""
            updateSongListByName(storedUsername, newSong: "\(songName) ")
        }
        
        // Implement logic to play the selected song or take other actions
    }

    func storeData(_ message: String) {
        let db = Firestore.firestore()
        let dataToStore = [
            message: Timestamp(date: Date())
        ]
        
        // Add a new document with a generated ID
        db.collection("messages").addDocument(data: dataToStore) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added successfully!")
            }
        }
    }
    func updateSongListByName(_ name: String, newSong: String) {
        successMessage.text="\(newSong) successfully recommended to your friends!"
        
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
                        "songList": FieldValue.arrayUnion([newSong])  // Add the new song to the songList
                    ]) { error in
                        if let error = error {
                            print("Error updating songList: \(error.localizedDescription)")
                        } else {
                            print("Successfully updated songList for user \(name)")
                        }
                    }
                }
            } else {
                print("No document found with the name \(name)")
            }
        }
    
    }
}
