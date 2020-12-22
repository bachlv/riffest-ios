import Foundation
import UIKit
import RealmSwift


class TrackController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    public static var sharedController = TrackController()
    var songs: [RMSong] = []
    let realm = try! Realm()
    var songsDB : Results<MyTrackDownloaded>!
    
    private func setupView(){
        tableView?.register(MyMusicTrackCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    
    fileprivate func retrieveDataFromDB(){
        self.songsDB = self.realm.objects(MyTrackDownloaded.self)
        for object in songsDB.reversed() {
            let dictionary = object.toDictionary() as NSDictionary
            let song = RMSong.init(withDictionary: dictionary)
            songs.append(song)
        }
        DispatchQueue.main.async {
            //if self.songsDB.count > 0 {
                self.tableView?.reloadData()
                self.tableView?.separatorStyle = .singleLine
           // }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrackController.sharedController = self
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveDataFromDB()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        songs = []
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func onHandleReload(song: [RMSong]){
//        DispatchQueue.main.async {
//            self.songs = song
//            self.tableView?.separatorStyle = .singleLine
//            self.tableView.reloadData()
//        }
//    }
   
}

extension TrackController{
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerController.sharedController.songs = self.songs
        PlayerController.sharedController.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.songs = self.songs
        (self.tabBarController as? CustomTabBarController)?.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.setUpShowPlayer()
        (self.tabBarController as? CustomTabBarController)?.handeSetUpPlayer()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 75
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyMusicTrackCell
        cell.song = songs[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
    
}
