import Foundation
import UIKit
import RealmSwift

class AlbumController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    public static var sharedController = AlbumController()
    var albums: [RMAlbum] = []
    let realm = try! Realm()
    var albumsDB : Results<AlbumDownloaded>!
    
    private func setupView(){
        tableView?.register(MyMusicAlbumCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    fileprivate func retrieveDataFromDB(){
        self.albumsDB = self.realm.objects(AlbumDownloaded.self)
        for object in albumsDB.reversed() {
            let dictionary = object.toDictionary() as NSDictionary
            let album = RMAlbum.init(withDictionary: dictionary)
            albums.append(album)
        }
        
        DispatchQueue.main.async {
            if self.albumsDB.count > 0 {
                self.tableView?.reloadData()
                self.tableView?.separatorStyle = .singleLine
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlbumController.sharedController = self
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveDataFromDB()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        albums = []
    }
    
    func onHandleReload(){
        DispatchQueue.main.async {
            self.tableView?.separatorStyle = .singleLine
            self.tableView.reloadData()
        }
    }
    
}

extension AlbumController{
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumFollowerController = AlbumFollowerController()
        albumFollowerController.albums = albums
        albumFollowerController.currentIndex = indexPath.row
        navigationController?.pushViewController(albumFollowerController, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyMusicAlbumCell
        cell.album = albums[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
    
}
