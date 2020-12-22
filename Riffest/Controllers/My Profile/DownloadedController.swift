import Foundation
import UIKit
import RealmSwift
import StreamingKit
import MarqueeLabel


class DownloadedController: UITableViewController {
    
    static var sharedController = DownloadedController()
    
    fileprivate let cellId = "cellId"
    // realm
    let realm = try! Realm()
    var songs : Results<SongDownloaded>!
    
    // no realm
    var songRM: [RMSong] = []
    
    private func setupView(){
        tableView?.register(DownloadCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    fileprivate func retrieveDataFromDB(){
        self.songs = self.realm.objects(SongDownloaded.self)
        for object in songs.reversed() {
            let dictionary = object.toDictionary() as NSDictionary
            let song = RMSong.init(withDictionary: dictionary)
            songRM.append(song)
        }
        DispatchQueue.main.async {
            if self.songRM.count > 0 {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DownloadedController.sharedController = self
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveDataFromDB()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        songRM = []
        DispatchQueue.main.async {
            self.tableView.setEditing(self.isEditing, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    @objc func onHandleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

extension DownloadedController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerController.sharedController.songs = self.songRM
        PlayerController.sharedController.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.songs = self.songRM
        (self.tabBarController as? CustomTabBarController)?.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.setUpShowPlayer()
        (self.tabBarController as? CustomTabBarController)?.handeSetUpPlayer()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songRM.count
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let songObject = realm.objects(SongDownloaded.self).filter("id == %@",songRM[indexPath.row].id!)
            if songObject.count > 0 {
                let url = URL(string: songRM[indexPath.row].url!)
                let path = URL(fileURLWithPath: AppStateHelper.shared.documents).appendingPathComponent((url?.lastPathComponent)!).path
                do {
                    try! self.realm.write {
                        self.realm.delete(songObject)
                    }
                    DispatchQueue.main.async {
                        self.songRM.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                    let fileManager = FileManager.default
                    try fileManager.removeItem(atPath: path)
                    print("Delete file successfully....")
                } catch {
                    print("Could not clear temp folder:")
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 65
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DownloadCell
        DispatchQueue.main.async {
            cell.textLabel?.text = self.songRM[indexPath.row].title
            cell.detailTextLabel?.text = self.songRM[indexPath.row].artist_name
            cell.imageView?.sd_setImage(with: URL(string: self.songRM[indexPath.row].poster!)!, placeholderImage: UIImage(named: "thumbnail"))
            cell.duringButton.setTitle(self.songRM[indexPath.row].duration, for: .normal)
        }
        cell.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size: 20)
        cell.separatorInset = UIEdgeInsets(top:0, left:15, bottom:0, right: 0)
        cell.layoutMargins = UIEdgeInsets(top:15, left:0, bottom:15, right: 0)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 75
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fView = UIView()
        return fView
    }
    func editCommand() {
        DispatchQueue.main.async {
            self.tableView.setEditing(!self.isEditing, animated: true)
        }
    }
    func doneCommand() {
        DispatchQueue.main.async {
            self.tableView.setEditing(self.isEditing, animated: true)
        }
    }
    
}
