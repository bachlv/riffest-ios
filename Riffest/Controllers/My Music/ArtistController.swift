import Foundation
import UIKit
import RealmSwift


class ArtistController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    public static var sharedController = ArtistController()
    var artists: [RMArtists] = []
    let realm = try! Realm()
    var artistsDB : Results<ArtistDownloaded>!
    
    private func setupView(){
        tableView?.register(MyMusicArtistCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    fileprivate func retrieveDataFromDB(){
        self.artistsDB = self.realm.objects(ArtistDownloaded.self)
        for object in artistsDB.reversed() {
            let dictionary = object.toDictionary() as NSDictionary
            let artist = RMArtists.init(withDictionary: dictionary)
            artists.append(artist)
        }
        
        DispatchQueue.main.async {
            if self.artistsDB.count > 0 {
                self.tableView?.reloadData()
                self.tableView?.separatorStyle = .singleLine
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ArtistController.sharedController = self
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveDataFromDB()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        artists = []
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

extension ArtistController{
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artistSingleController = ArtistSingleController()
        artistSingleController.artists = artists
        artistSingleController.currentIndex = indexPath.row
        navigationController?.pushViewController(artistSingleController, animated: true)
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
        return artists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyMusicArtistCell
        cell.artist = artists[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
    
}
