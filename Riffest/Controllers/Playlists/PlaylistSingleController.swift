import Foundation
import UIKit


class PlaylistSingleController: UITableViewController {
    
    static var sharedController = PlaylistSingleController()
    
    fileprivate let cellId = "cellId"
    fileprivate let cellTrackId = "cellTrackId"
    
    var playlists: [RMMyPlaylist] = []
    var currentIndex: Int = 0
    weak var actionToEnable : UIAlertAction?

    var search = ""
    var next_page = 0
    var last_page = 0
    
    var url: String = "mobile/user/playlists"
    var subView = UIView()
    var songs: [RMSong] = []
    
    var isEditPlaylist: Bool = false
    
    lazy var shuffleButton: UIButton = {
        let button = ShuffleButton(type: .system)
        button.tintColor = UIColor.white
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.themeBaseColor()
        button.isUserInteractionEnabled = true
        button.setTitle("Shuffle", for: .normal)
        button.titleLabel?.font =  AppStateHelper.shared.defaultFontRegular(size: 15)
        return button
    }()
    let TracksLabel: UILabel = {
        let label = UILabel()
        label.font = AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = SAFollowButton(type: .system)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.themeBaseColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.setTitle("\u{f004} Follow", for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(onHandleFollowAndUnFollow), for: .touchUpInside)
        button.titleLabel?.font =  AppStateHelper.shared.defaultFontAwesome(size:15)
        return button
    }()
    
    
    private func setupView(){
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellTrackId)
        tableView?.register(PlaylistTrackCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        if isEditPlaylist {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onHandleEditPlaylist))
        }
        
    }
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    let ImageViewCover: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let NameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppStateHelper.shared.defaultFontRegular(size:18)
        return label
    }()
    
    let ByLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppStateHelper.shared.defaultFontRegular(size:12)
        return label
    }()
    
    let TotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppStateHelper.shared.defaultFontRegular(size:10)
        return label
    }()
    
    let TotalFollowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppStateHelper.shared.defaultFontRegular(size:12)
        return label
    }()
    
    var subViewProfile = UIView()
    
    private func setupViewAction(){
        shuffleButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        shuffleButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        shuffleButton.centerYAnchor.constraint(equalTo: subView.centerYAnchor).isActive = true
        shuffleButton.rightAnchor.constraint(equalTo: subView.rightAnchor, constant: -15).isActive = true
        shuffleButton.addTarget(self, action: #selector(onHandleshuffle), for: .touchUpInside)
        shuffleButton.layer.cornerRadius = 3
        shuffleButton.clipsToBounds = true
        TracksLabel.text = "Tracks"
        TracksLabel.translatesAutoresizingMaskIntoConstraints = false
        TracksLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        TracksLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        TracksLabel.centerYAnchor.constraint(equalTo: subView.centerYAnchor).isActive = true
        TracksLabel.leftAnchor.constraint(equalTo: subView.leftAnchor, constant: 15).isActive = true
    }
    
    private func setupViewProfile(){
        
        ImageViewCover.translatesAutoresizingMaskIntoConstraints = false
        ImageViewCover.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        ImageViewCover.heightAnchor.constraint(equalToConstant: 180).isActive = true
        ImageViewCover.leftAnchor.constraint(equalTo: subViewProfile.leftAnchor).isActive = true
        ImageViewCover.topAnchor.constraint(equalTo: subViewProfile.topAnchor ).isActive = true
        
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        visualEffectView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        visualEffectView.leftAnchor.constraint(equalTo: subViewProfile.leftAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: subViewProfile.topAnchor ).isActive = true
        
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        ImageView.leftAnchor.constraint(equalTo: subViewProfile.leftAnchor, constant: 15).isActive = true
        ImageView.topAnchor.constraint(equalTo: subViewProfile.topAnchor, constant: 17).isActive = true
        
        NameLabel.translatesAutoresizingMaskIntoConstraints = false
        NameLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 145).isActive = true
        NameLabel.topAnchor.constraint(equalTo: subViewProfile.topAnchor, constant: 15).isActive = true
        
        ByLabel.translatesAutoresizingMaskIntoConstraints = false
        ByLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 145).isActive = true
        ByLabel.bottomAnchor.constraint(equalTo: NameLabel.bottomAnchor, constant: 15).isActive = true
        
        TotalLabel.translatesAutoresizingMaskIntoConstraints = false
        TotalLabel.widthAnchor.constraint(equalToConstant: 140).isActive  = true
        TotalLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor,  constant: 145).isActive = true
        TotalLabel.bottomAnchor.constraint(equalTo: ByLabel.bottomAnchor, constant: 15).isActive = true
        
        followButton.widthAnchor.constraint(equalToConstant: 120).isActive  = true
        followButton.heightAnchor.constraint(equalToConstant: 35).isActive  = true
        followButton.bottomAnchor.constraint(equalTo: TotalLabel.bottomAnchor, constant: 45).isActive = true
        followButton.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 145).isActive = true
        
        TotalFollowLabel.translatesAutoresizingMaskIntoConstraints = false
        TotalFollowLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 145).isActive = true
        TotalFollowLabel.bottomAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 20).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlaylistSingleController.sharedController = self
        setupView()
        onHandleRequestData()
        onHandleGetSong()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = playlists[currentIndex].title
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onHandleshuffle(){
        
    }
    
    @objc func onHandleFollowAndUnFollow(sender: UIButton){
        if sender.tag == 1{
            // unfollow
            let body = ["playlist_id": "\(playlists[currentIndex].id ?? 0)"]
            PlaylistService.onHandleFollowAndUnfollow("mobile/user/playlists/unfollow","POST",body,onSuccess: { (follow) in
                DispatchQueue.main.async {
                    self.onHandleRequestData()
                    sender.tag = 0
                }
            })
        }else {
            // following
            let body = ["playlist_id": "\(playlists[currentIndex].id ?? 0)"]
            PlaylistService.onHandleFollowAndUnfollow("mobile/user/playlists/following","POST",body,onSuccess: { (follow) in
                DispatchQueue.main.async {
                    sender.tag = 1
                    self.onHandleRequestData()
                }
            })
        }
    }
    
    func onHandleRequestData(){
        let playlistId = "\(playlists[currentIndex].id ?? 0)"
        PlaylistService.onHandleViewPlaylistProfile(
            url+"/"+playlistId,{ (playlist, follow) in
                DispatchQueue.main.async {
                    
                    self.ByLabel.text = "By \(playlist?.name ?? "")"
                    self.TotalFollowLabel.text = "\(playlist?.followers ?? 0) followers"
                    if follow == true {
                        self.followButton.tag = 1
                        self.followButton.setTitle("\u{f004} Following", for: .normal)
                    }else {
                        self.followButton.tag = 0
                        self.followButton.setTitle("\u{f004} Follow", for: .normal)
                    }
                }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                // AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }

        })
    }
    
    //
   
    func onHandleGetSong(){
        let playlistId = "\(playlists[currentIndex].id ?? 0)"
        PlaylistService.onHandleGetSongByID("mobile/user/playlists/song"+"/"+playlistId,{ (song) in
            DispatchQueue.main.async {
                self.songs = song
                self.TotalLabel.text = "\(self.songs.count) Track(s)"
                self.tableView?.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
              //  AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }

        })
        
    }
    
    @objc func onHandleEditPlaylist(){
        AppStateHelper.shared.onHandleEditControlPlaylist(playlist: playlists[currentIndex])
    }
    
    @objc  func onHandleEditPlaylistTrack(){
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
        }else {
            tableView.setEditing(true, animated: true)
        }
    }
    
    @objc func onHandleEditPlaylistTitle () {
        let alert = UIAlertController(title: "Edit Playlist", message: "Enter a text", preferredStyle: .alert)
        let placeholderStr =  "Edit Playlist"
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = placeholderStr
            textField.text = "\(self.playlists[self.currentIndex].title!)"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) -> Void in
        })
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) -> Void in
            let textfield = alert.textFields![0]
            let playlistId = "\(self.playlists[self.currentIndex].id ?? 0)"
            let body = ["title": textfield.text! ]
            RMService.onHandlePostPlaylist("mobile/user/playlists/update/"+playlistId,"POST",body,onSuccess: { (playlist) in
                DispatchQueue.main.async {
                    if(playlist == true){
                        AppStateHelper.shared.onHandleAlertNotifi(title: "\(self.playlists[self.currentIndex].title!) has been updated.")
                        self.playlists[self.currentIndex].title = textfield.text!
                        self.tableView.reloadData()
                    }else{
                        DispatchQueue.main.async {
                            AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                        }
                    }
                }
            })
        })
        alert.addAction(cancel)
        alert.addAction(action)
        self.actionToEnable = action
        action.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textChanged(_ sender:UITextField) {
        if(sender.text!.isEmpty){
            self.actionToEnable?.isEnabled = false
        }else {
            self.actionToEnable?.isEnabled = true
        }
    }
}

extension PlaylistSingleController {
    
    @objc func onHandleChangeStatusPlaylist(playlist: RMMyPlaylist){
        var status: Int = 0
        if playlist.status == 0 {
            status = 1
        }else{
            status = 0
        }
        let body = ["playlist_id": "\(playlist.id ?? 0)", "status": "\(status)"]
        PlaylistService.onHandlePlaylistAction("mobile/user/playlists/status","POST",body,onSuccess: { (success) in
            DispatchQueue.main.async {
                self.playlists[self.currentIndex].status = status
                self.tableView.reloadData()
            }
        })
        
        
    }
    @objc func onHandleRemovePlaylist(playlist: RMMyPlaylist){
        let playlistId = "\(playlist.id ?? 0)"
            PlaylistService.onHandleRemovePlaylist("mobile/user/playlists/delete/"+playlistId,"POST",
            onSuccess: { (success) in
            DispatchQueue.main.async {
                if success {
                    AppStateHelper.shared.onHandleAlertNotifi(title:"\"\(playlist.title!)\""+" has been removed.")
                    self.navigationController?.popViewController(animated: true)
                }else {
                    DispatchQueue.main.async {
                        AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                    }
                }
            }
        })
    }
    
    
}


extension PlaylistSingleController {
    
   
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let playlistId = "\(self.playlists[self.currentIndex].id ?? 0)"
            let body = ["playlist_id": playlistId, "song_id": "\(self.songs[indexPath.row].id!)"]
            PlaylistService.onHandlePlaylistAction("playlists/song/delete","POST",body,onSuccess: { (success) in
                DispatchQueue.main.async {
                    self.onHandleGetSong()
                }
            })
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return 0
        } else {
            return 75
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 180
        } else {
            return 55
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            subViewProfile.backgroundColor = UIColor.white
            DispatchQueue.main.async {
                self.NameLabel.text = self.playlists[self.currentIndex].title
                self.ImageView.sd_setImage(with: URL(string: (self.playlists[self.currentIndex].poster!))!, placeholderImage: UIImage(named: "thumbnail"))
                self.ImageViewCover.sd_setImage(with: URL(string: (self.playlists[self.currentIndex].poster!))!, placeholderImage: UIImage(named: "thumbnail"))
            }
            subViewProfile.addSubview(ImageViewCover)
            ImageViewCover.addSubview(visualEffectView)
            subViewProfile.addSubview(ImageView)
            subViewProfile.addSubview(NameLabel)
            subViewProfile.addSubview(ByLabel)
            subViewProfile.addSubview(TotalLabel)
            subViewProfile.addSubview(followButton)
            subViewProfile.addSubview(TotalFollowLabel)
            setupViewProfile()
            return subViewProfile
        } else {
            subView.backgroundColor = UIColor.themeHeaderColor()
            subView.addSubview(TracksLabel)
            subView.addSubview(shuffleButton)
            setupViewAction()
            return subView
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0{
            PlayerController.sharedController.songs = self.songs
            PlayerController.sharedController.indexPlaying = indexPath.row
            (self.tabBarController as? CustomTabBarController)?.songs = self.songs
            (self.tabBarController as? CustomTabBarController)?.indexPlaying = indexPath.row
            (self.tabBarController as? CustomTabBarController)?.setUpShowPlayer()
            (self.tabBarController as? CustomTabBarController)?.handeSetUpPlayer()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 0
        } else {
            return songs.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlaylistTrackCell
        cell.song = self.songs[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
    
}
