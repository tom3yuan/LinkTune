import UIKit
import Firebase


class SearchScreen: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var allSongs: [String] = []
    var filteredSongs: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the delegates
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.alpha = 0

        // Load all songs from the "SongData" folder
        loadSongs()
        filteredSongs = allSongs // Initialize filtered songs with all songs
        tableView.reloadData()
    }

    func loadSongs() {
        // Get the path for the "SongData" directory
        if let songDataPath = Bundle.main.resourcePath?.appending("/SongData") {
            do {
                print("IT WORKS")
                let fileManager = FileManager.default
                // List all files in the directory
                let files = try fileManager.contentsOfDirectory(atPath: songDataPath)
                
                // Filter for only song files (e.g., .mp3)
                allSongs = files.filter { $0.hasSuffix(".mp3") || $0.hasSuffix(".wav") }
            } catch {
                print("Error reading contents of SongData directory: \(error)")
            }
        } else {
            print("Song data not found")
        }
            
        print("All songs loaded: \(allSongs)")
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Show all songs if search text is empty
            filteredSongs = allSongs
        } else {
            // Filter songs based on the search text
            filteredSongs = allSongs.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
        tableView.reloadData() // Reload the table view to display filtered results
    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            // Hide the table view and clear results
//            UIView.animate(withDuration: 0.3) {
//                self.tableView.alpha = 0
//            }
//            filteredSongs = [] // Clear the filtered songs
//        } else {
//            // Show the table view and filter results
//            UIView.animate(withDuration: 0.3) {
//                self.tableView.alpha = 1
//            }
//            filteredSongs = allSongs.filter { $0.localizedCaseInsensitiveContains(searchText) }
//        }
//        tableView.reloadData()
//    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSongs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        cell.textLabel?.text = filteredSongs[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = filteredSongs[indexPath.row]
        // Implement the code to play the selected song
        print("Selected song: \(selectedSong)")
    }
}
