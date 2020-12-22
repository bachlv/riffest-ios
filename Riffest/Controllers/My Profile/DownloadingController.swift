import Foundation
import UIKit
import RealmSwift
import StreamingKit
import MarqueeLabel

@objc protocol DownloadingCellDelegate {
    //    func onHandleResumeDown(indexPath: Int)
    //    func onHandlePaue(indexPath: Int)
}

public let doneNotificationName =  "doneNotificationName"

class DownloadingController: UITableViewController, DownloadingCellDelegate {
    
    static var sharedController = DownloadingController()
    
    fileprivate let cellId = "cellId"
    var songRM: RMSong?
    
    let alertControllerViewTag: Int = 500
    var selectedIndexPath : IndexPath!

    let myDownloadPath = MZUtility.baseFilePath + "/Riffest"
    lazy var downloadManager: MZDownloadManager = {
        [unowned self] in
        let sessionIdentifer: String = "vn.bachle.Riffest.BackgroundSession"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
        
        }()
    
    let realm = try! Realm()
    var songRMDownloading: Results<SongDownloading>!
    
    init() {
        super.init(style: .plain)
        self.songRMDownloading = self.realm.objects(SongDownloading.self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView(){
        tableView?.register(DownloadingCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .singleLine
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.themeBaseColor()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DownloadingController.sharedController = self
        setupView()
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let aString: NSString = "temp" as NSString
        aString.appendingPathComponent("")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.songRMDownloading = self.realm.objects(SongDownloading.self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.tableView.setEditing(self.isEditing, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // refactor code download
    func addSongDownloading(song: RMSong) {
            let trackObject = SongDownloading()
            trackObject.id = song.id!
            trackObject.songID = String(describing: song.id!)
            trackObject.artist_name = song.artist_name!
            trackObject.poster = song.poster!
            trackObject.title = song.title!
            trackObject.duration = song.duration!
            trackObject.url = song.url!
            trackObject.artistId = song.artistId!
            if song.album_id != nil {
                trackObject.album_id = song.album_id!
            }
            trackObject.picture =  song.picture!
        
            try! self.realm.write {
                self.realm.add(trackObject)
            }
            self.tableView.reloadData()
            let index = self.songRMDownloading.index(of: trackObject)!
            let indexPathRow = IndexPath(row: index, section: 0)
            let cell = self.tableView.cellForRow(at: indexPathRow) as? DownloadingCell
            if (cell != nil) {
                cell?.downloadButton.state = .downloading
                let fileURL: NSString = songRM!.url! as NSString
                var fileName : NSString = fileURL.lastPathComponent as NSString
                fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(fileName as String) as NSString)
                downloadManager.addDownloadTask(fileName as String, fileURL: fileURL as String, destinationPath: myDownloadPath)
            }
    }
    
    func onHandleReloadTable() {
        self.tableView.reloadData()
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

extension DownloadingController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let downloadModel = downloadManager.downloadingArray[indexPath.row]
        self.showAppropriateActionController(downloadModel.status)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 65
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songRMDownloading.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DownloadingCell
        DispatchQueue.main.async {
           cell.textLabel?.text = self.songRMDownloading[indexPath.row].title
           cell.detailTextLabel?.text = self.songRMDownloading[indexPath.row].artist_name
           cell.imageView?.sd_setImage(with: URL(string: self.songRMDownloading[indexPath.row].poster)!, placeholderImage: UIImage(named: "thumbnail"))
        }
        cell.indexPathRow = indexPath.row
        cell.delegate = self
        
        cell.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size: 14)
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! self.realm.write {
                self.downloadManager.cancelTaskAtIndex(indexPath.row)
                self.realm.delete(songRMDownloading[indexPath.row])
            }
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

extension DownloadingController {
    
    func showAppropriateActionController(_ requestStatus: String) {
        
        if requestStatus == TaskStatus.downloading.description() {
            self.showAlertControllerForPause()
        } else if requestStatus == TaskStatus.failed.description() {
            self.showAlertControllerForRetry()
        } else if requestStatus == TaskStatus.paused.description() {
            self.showAlertControllerForStart()
        }
    }
    
    
    func refreshCellForIndex(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath)
        if let cell = cell {
            let downloadCell = cell as! DownloadingCell
            downloadCell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        }
    }
    func showAlertControllerForRetry() {
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.retryDownloadTaskAtIndex(self.selectedIndexPath.row)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
            self.onHandleRemoveDownloading()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(retryAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertControllerForPause() {
        let pauseAction = UIAlertAction(title: "Pause", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.pauseDownloadTaskAtIndex(self.selectedIndexPath.row)
        }
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
            self.onHandleRemoveDownloading()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(pauseAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlertControllerForStart() {
        let startAction = UIAlertAction(title: "Start", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.resumeDownloadTaskAtIndex(self.selectedIndexPath.row)
        }
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
            self.onHandleRemoveDownloading()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(startAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func onHandleRemoveDownloading() {
        if self.songRMDownloading[self.selectedIndexPath.row].songID != nil {
            try! self.realm.write {
                self.realm.delete(self.songRMDownloading[self.selectedIndexPath.row])
            }
            tableView.deleteRows(at: [IndexPath(row: self.selectedIndexPath.row, section: 0)], with: .left)
        }
    }
}


extension DownloadingController: MZDownloadManagerDelegate {
    
    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        print("downloadModel", downloadModel.fileURL)
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
        tableView.reloadData()
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        print("downloadRequestDidUpdateProgress===", index)
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        print("downloadRequestDidPaused", index)
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        print("downloadRequestDidResumed===", index)
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        print("downloadRequestCanceled==")
    }
    
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
        let songModel = SongDownloaded()
        songModel.songID = String(describing: songRMDownloading[index].id)
        songModel.id = songRMDownloading[index].id
        songModel.title = songRMDownloading[index].title
        songModel.url = songRMDownloading[index].url
        songModel.poster = songRMDownloading[index].poster
        songModel.duration = songRMDownloading[index].duration
        songModel.artist_name = songRMDownloading[index].artist_name
        try! self.realm.write {
            self.realm.add(songModel)
            self.realm.delete(self.songRMDownloading[index])
        }
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")
        let docDirectoryPath : NSString = (MZUtility.baseFilePath as NSString).appendingPathComponent(downloadModel.fileName) as NSString
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif as String), object: docDirectoryPath)
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        print("downloadRequestDidFailedWithError")
        self.refreshCellForIndex(downloadModel, index: index)
    }
    //Oppotunity to handle destination does not exists error
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        try? FileManager.default.removeItem(at: location)
        print(" handle destination does not exists error")
    }
}
