import Foundation
import UIKit
import RealmSwift

class FollowingPlaylistController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    public static var sharedController = FollowingPlaylistController()

    var playlists: [RMMyPlaylist] = []
    let realm = try! Realm()
    var playlistsDB : Results<MyPlaylistDownloaded>!
    
    private func setupView(){
        tableView?.register(MyMusicPlaylistCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    fileprivate func retrieveDataFromDB(){
        self.playlistsDB = self.realm.objects(MyPlaylistDownloaded.self)
        for object in playlistsDB.reversed() {
            let dictionary = object.toDictionary() as NSDictionary
            let playlist = RMMyPlaylist.init(withDictionary: dictionary)
            playlists.append(playlist)
        }
        
        DispatchQueue.main.async {
            if self.playlistsDB.count > 0 {
                self.tableView?.reloadData()
                self.tableView?.separatorStyle = .singleLine
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FollowingPlaylistController.sharedController = self
       setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveDataFromDB()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playlists = []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func onHandleReload(){
        DispatchQueue.main.async {
            self.tableView?.separatorStyle = .singleLine
            self.tableView.reloadData()
        }
    }
    
    
}

extension FollowingPlaylistController{
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistSingleController = FeaturedPlaylistSingleController()
        playlistSingleController.playlists = playlists
        playlistSingleController.currentIndex = indexPath.row
        navigationController?.pushViewController(playlistSingleController, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 101
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyMusicPlaylistCell
        cell.playlist = playlists[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }

}
