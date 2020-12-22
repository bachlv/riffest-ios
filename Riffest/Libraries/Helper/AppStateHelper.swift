import Foundation
import UIKit
import RealmSwift
import NVActivityIndicatorView

var reachability = Reachability()

class AppStateHelper: UIViewController, NVActivityIndicatorViewable {
    
    static let shared = AppStateHelper()
    var alertController = UIAlertController()
    var customTabBarController: CustomTabBarController?
    let realm = try! Realm()
    var notReachable: Bool = false
    
    var documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Riffest/"
        
    
    func defaultFontAwesome(size: CGFloat) -> UIFont {
        return UIFont(name: "FontAwesome", size: size)!
    }
    
    func defaultFontBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
    }
    func defaultFontRegular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.regular)
    }
    
    func handleRequestDataHome(){
        self.customTabBarController?.onHandleRequestData()
    }
   
    func onHandleAlertNotifi(title:String){
        customTabBarController?.onHandleAlertNotifi(title: title)
    }
    func onHandleAlertNotifiError(title:String){
        customTabBarController?.onHandleAlertNotifiError(title: title)
    }
    func onHandleSongMore(song: RMSong, button: UIButton){
        
        let actionSheetController: UIAlertController = UIAlertController(title: "\n\n\n", message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.themeBaseColor()

        let imageArtist = UIImageView()
        let titleLable = UILabel()
        let nameLable = UILabel()
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: actionSheetController.view.bounds.size.width - margin * 0.0, height: 0)
        let customView = UIView(frame: rect)
        actionSheetController.view.addSubview(customView)
        customView.addSubview(imageArtist)
        customView.addSubview(titleLable)
        customView.addSubview(nameLable)
        imageArtist.leftAnchor.constraint(equalTo: customView.leftAnchor).isActive = true
        imageArtist.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
        imageArtist.translatesAutoresizingMaskIntoConstraints = false
        imageArtist.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageArtist.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageArtist.layer.cornerRadius = 3.0
        imageArtist.clipsToBounds = true
        titleLable.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: imageArtist.leftAnchor, constant: 70).isActive = true
        titleLable.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -40).isActive = true
        
        titleLable.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
        titleLable.textColor = UIColor.themeBaseColor()
        titleLable.font = AppStateHelper.shared.defaultFontRegular(size: 16)
        
        nameLable.translatesAutoresizingMaskIntoConstraints = false
        nameLable.textColor = UIColor.gray
        nameLable.font = AppStateHelper.shared.defaultFontRegular(size: 15)
        nameLable.bottomAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 23).isActive = true
        nameLable.leftAnchor.constraint(equalTo: imageArtist.leftAnchor, constant: 70).isActive = true
        nameLable.widthAnchor.constraint(equalToConstant: actionSheetController.view.bounds.size.width - 70).isActive = true
        nameLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        DispatchQueue.main.async {
            nameLable.text = song.artist_name
            titleLable.text = song.title
            imageArtist.sd_setImage(with: URL(string: song.poster!)!, placeholderImage: UIImage(named: "poster"))
        }
        let artistAction: UIAlertAction = UIAlertAction(title: "Go to artist", style: .default) { action -> Void in
            if button.tag == 1{
                PlayerController.sharedController.onHandleClose()
            }
            HomeController.sharedController.onHandleGoToArtist(artistSong: song)
        }
        let albumAction: UIAlertAction = UIAlertAction(title: "Go to album", style: .default) { action -> Void in
            if button.tag == 1{
                PlayerController.sharedController.onHandleClose()
            }
            HomeController.sharedController.onHandleGoToAlbum(albumSong: song)
        }
        
        let removeTrackAction: UIAlertAction = UIAlertAction(title: "Remove track", style: .default) { action -> Void in
            print("remove")
            self.onHandleConfirmDelete(song: song)
        }
        
        let downloadAction: UIAlertAction = UIAlertAction(title: "Download", style: .default) { action -> Void in
            self.addDownload(song: song)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        artistAction.setValue(UIImage(named: "artist-1"), forKey: "image")
        albumAction.setValue(UIImage(named: "album"), forKey: "image")
        downloadAction.setValue(UIImage(named: "download"), forKey: "image")
        removeTrackAction.setValue(UIImage(named: "trash"), forKey: "image")

        artistAction.setValue(0, forKey: "titleTextAlignment")
        albumAction.setValue(0, forKey: "titleTextAlignment")
        downloadAction.setValue(0, forKey: "titleTextAlignment")
        removeTrackAction.setValue(0, forKey: "titleTextAlignment")

        
        actionSheetController.addAction(artistAction)
        if song.album_id != nil{
            actionSheetController.addAction(albumAction)
        }
        if button.tag == 2{
            actionSheetController.addAction(removeTrackAction)
        }else {
            actionSheetController.addAction(downloadAction)
        }
        
        actionSheetController.addAction(cancelAction)
        
        if let popoverController = actionSheetController.popoverPresentationController {
            self.view.frame = UIScreen.main.bounds
            popoverController.sourceView = button
            popoverController.sourceRect = CGRect(x: button.bounds.midX, y: button.bounds.midY, width: 0, height: 0)
        }
        actionSheetController.show()
    }
    func addDownload(song: RMSong){
        let body = ["song_id": "\(song.id ?? 0)"]
        TrackerService.onHandleTracker("mobile/song/download","POST",body,onSuccess: { (success) in
            if success == false {
                DispatchQueue.main.async {
                    self.onHandleAlertNotifiError(title: "Unable to Download Music. Please Try Again Later")
                }
            return
            }
        })
        let realm = try! Realm()
        let existMusic = realm.object(ofType: SongDownloaded.self, forPrimaryKey: String(describing: song.id!))
        let existMusicDownloading = realm.object(ofType: SongDownloading.self, forPrimaryKey: String(describing: song.id!))
        if existMusic != nil || existMusicDownloading != nil {
            DispatchQueue.main.async {
                self.onHandleAlertNotifiError(title: "Song already exists")
            }
        }else {
            DownloadingController.sharedController.songRM = song
            DownloadingController.sharedController.addSongDownloading(song: song)
            DispatchQueue.main.async {
                self.onHandleAlertNotifi(title: "Downloading \(song.title!)")
            }
        }
    }
    
    func onHandleConfirmDelete(song: RMSong){
        let alertController = UIAlertController(title: "Riffest", message: "Move to trash ? Can't be undo.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            let body = ["song_id": [song.song_download_id ?? 0]]
            TrackerService.onHandleTrackerRemove("mobile/mymusic/download/delete","POST",body,onSuccess: { (success) in
                if success == true {
                    print("success here", success)
                    MyMusicController.sharedController.onHandleGetSong()
                }else {
                    print("failed", success)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.show()
    }
    
    
    func onHandleEditControlPlaylist(playlist: RMMyPlaylist){
        
        let actionSheetController: UIAlertController = UIAlertController(title: "\n\n\n", message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.themeBaseColor()
        
        let imageArtist = UIImageView()
        let titleLable = UILabel()
        var statusTitle: String = ""
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: actionSheetController.view.bounds.size.width - margin * 0.0, height: 0)
        let customView = UIView(frame: rect)
        actionSheetController.view.addSubview(customView)
        customView.addSubview(imageArtist)
        customView.addSubview(titleLable)
        
        imageArtist.leftAnchor.constraint(equalTo: customView.leftAnchor).isActive = true
        imageArtist.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
        imageArtist.translatesAutoresizingMaskIntoConstraints = false
        imageArtist.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageArtist.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageArtist.layer.cornerRadius = 3.0
        imageArtist.clipsToBounds = true
        titleLable.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: imageArtist.leftAnchor, constant: 70).isActive = true
        titleLable.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -40).isActive = true
        
        titleLable.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
        titleLable.textColor = UIColor.themeBaseColor()
        titleLable.font = AppStateHelper.shared.defaultFontRegular(size: 16)
        
        DispatchQueue.main.async {
            titleLable.text = playlist.title
            imageArtist.sd_setImage(with: URL(string: playlist.poster!)!, placeholderImage: UIImage(named: "poster"))
        }
        let renameAction: UIAlertAction = UIAlertAction(title: "Rename", style: .default) { action -> Void in
            PlaylistSingleController.sharedController.onHandleEditPlaylistTitle()
        }
        let editTrackAction: UIAlertAction = UIAlertAction(title: "Edit Tracks", style: .default) { action -> Void in
            PlaylistSingleController.sharedController.onHandleEditPlaylistTrack()

        }
        if playlist.status == 1 {
            statusTitle = "Set private"
        }else {
            statusTitle = "Set public"
        }
        let statusAction: UIAlertAction = UIAlertAction(title: statusTitle, style: .default) { action -> Void in
            PlaylistSingleController.sharedController.onHandleChangeStatusPlaylist(playlist: playlist)
        }
        
        let shareAction: UIAlertAction = UIAlertAction(title: "Share to facebook", style: .default) { action -> Void in
        }
        let removeAction: UIAlertAction = UIAlertAction(title: "Remove playlist", style: .default) { action -> Void in
            PlaylistSingleController.sharedController.onHandleRemovePlaylist(playlist: playlist)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        renameAction.setValue(UIImage(named: "edit"), forKey: "image")
        editTrackAction.setValue(UIImage(named: "track"), forKey: "image")
        if playlist.status == 1{
            statusAction.setValue(UIImage(named: "locks"), forKey: "image")
        }else {
            statusAction.setValue(UIImage(named: "padlock"), forKey: "image")
        }
        shareAction.setValue(UIImage(named: "share-1"), forKey: "image")
        removeAction.setValue(UIImage(named: "trash"), forKey: "image")
        
        renameAction.setValue(0, forKey: "titleTextAlignment")
        editTrackAction.setValue(0, forKey: "titleTextAlignment")
        statusAction.setValue(0, forKey: "titleTextAlignment")
        shareAction.setValue(0, forKey: "titleTextAlignment")
        removeAction.setValue(0, forKey: "titleTextAlignment")
        
        actionSheetController.addAction(renameAction)
        actionSheetController.addAction(editTrackAction)
        actionSheetController.addAction(statusAction)
        actionSheetController.addAction(shareAction)
        actionSheetController.addAction(removeAction)
        
        actionSheetController.addAction(cancelAction)
    
        
        if let popoverController = actionSheetController.popoverPresentationController {
            view.frame = UIScreen.main.bounds
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.maxX, y: view.bounds.maxY, width: 0, height: 0)
        }
     
        actionSheetController.show()
    }
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    func onHandleHideIndicator(){
        DispatchQueue.main.async {
              self.stopAnimating(nil)
        }
    }
    func onHandleShowIndicator(){
        let size = CGSize(width: 30, height: 30)
        let indicatorType = presentingIndicatorTypes[24]
        startAnimating(size, message: "Loading...", type: indicatorType, fadeInAnimation: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Preparing...")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.stopAnimating(nil)
        }
    }

   
    func checkNetwork(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusChanged(_:)), name: .reachabilityChanged, object: nil)
    }
    @objc func reachabilityStatusChanged(_ sender: NSNotification) {
        guard let networkStatus = (sender.object as? Reachability)?.currentReachabilityStatus() else { return }
        if networkStatus == NotReachable {
            notReachable = true
            print("No internet")
        }else{
            print("internet")
            notReachable = false
        }
    }
    
    func updateInterfaceWithCurrent(networkStatus: NetworkStatus) {
        switch networkStatus {
        case NotReachable:
            print("NotReachable")
            notReachable = true
        case ReachableViaWiFi:
            notReachable = false
            print("Reachable Internet")
        case ReachableViaWWAN:
            notReachable = false
            print("Reachable Cellular")
        default:
            return
        }
        
    }
    
}

class CustomProgressUISlider : UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: UIScreen.main.bounds.width - 40, height: 7.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}
class CustomProgressTopUISlider : UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: UIScreen.main.bounds.width + 6, height: 8.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}


