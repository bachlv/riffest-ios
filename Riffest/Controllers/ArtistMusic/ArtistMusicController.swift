import Foundation
import UIKit


class ArtistMusicController: UITableViewController {
    
    static var sharedController = ArtistMusicController()
    fileprivate let cellId = "cellId"
    fileprivate let cellTrackId = "cellTrackId"

    var artistSong: RMSong?
    var currentMusicIndex: Int = 0
    
    var search = ""
    var next_page = 0
    var last_page = 0
    
    var url: String = "mobile/artists/view"
    var artists: [RMArtists] = []
    var songs: [RMSong] = []
    
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
    
    var subView = UIView()

    private func setupView(){
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellTrackId)
        tableView?.register(ArtistTrackCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
         tableView.tableFooterView = UIView(frame: .zero)
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
        //NameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        NameLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 145).isActive = true
        NameLabel.topAnchor.constraint(equalTo: subViewProfile.topAnchor, constant: 15).isActive = true
        
        TotalLabel.translatesAutoresizingMaskIntoConstraints = false
        TotalLabel.widthAnchor.constraint(equalToConstant: 140).isActive  = true
        TotalLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor,  constant: 145).isActive = true
        TotalLabel.bottomAnchor.constraint(equalTo: NameLabel.bottomAnchor, constant: 15).isActive = true
        
        followButton.widthAnchor.constraint(equalToConstant: 120).isActive  = true
        followButton.heightAnchor.constraint(equalToConstant: 35).isActive  = true
        followButton.bottomAnchor.constraint(equalTo: TotalLabel.bottomAnchor, constant: 45).isActive = true
        followButton.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 145).isActive = true
        
        TotalFollowLabel.translatesAutoresizingMaskIntoConstraints = false
        TotalFollowLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 145).isActive = true
        TotalFollowLabel.bottomAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 20).isActive = true
        
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ArtistMusicController.sharedController = self
        setupView()
        onHandleRequestData()
        onHandleGetSong()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = artistSong?.artist_name

     
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
            let body = ["artist_id": "\(artistSong?.artistId ?? 0)"]
            RMArtistService.onHandleFollowAndUnfollow("mobile/artists/unfollow","POST",body,onSuccess: { (follow) in
                DispatchQueue.main.async {
                    self.onHandleRequestData()
                    sender.tag = 0
                }
            })
        }else {
            // following
            let body = ["artist_id": "\(artistSong?.artistId ?? 0)"]
            RMArtistService.onHandleFollowAndUnfollow("mobile/artists/following","POST",body,onSuccess: { (follow) in
                DispatchQueue.main.async {
                    sender.tag = 1
                    self.onHandleRequestData()
                }
            })
        }
    }
  
    func onHandleRequestData(){
        let artistId = "\(artistSong?.artistId ?? 0)"
        RMArtistService.onHandleViewArtistProfile(
            url+"/"+artistId,{ (artist, follow) in
            DispatchQueue.main.async {
                self.TotalFollowLabel.text = "\(artist?.followers ?? 0) followers"
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
                 AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                }

        })
    }
    
    func onHandleGetSong(){
        let artistId = "\(artistSong?.artistId ?? 0)"
        RMArtistService.onHandleGetSongByID("mobile/artists/song"+"/"+artistId,{ (song) in
                DispatchQueue.main.async {
                    self.songs = song
                    self.TotalLabel.text = "\(self.songs.count) Track(s)"
                    self.tableView?.separatorStyle = .singleLine
                    self.tableView.reloadData()
                }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                 AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                }

        })
        
    }
    

}

extension ArtistMusicController {
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
                    self.NameLabel.text = self.artistSong?.artist_name
                    self.ImageView.sd_setImage(with: URL(string: (self.artistSong?.picture!)!)!, placeholderImage: UIImage(named: "thumbnail"))
                    self.ImageViewCover.sd_setImage(with: URL(string: (self.artistSong?.picture!)!)!, placeholderImage: UIImage(named: "thumbnail"))
                }
                subViewProfile.addSubview(ImageViewCover)
                ImageViewCover.addSubview(visualEffectView)
                subViewProfile.addSubview(ImageView)
                subViewProfile.addSubview(NameLabel)
                subViewProfile.addSubview(TotalLabel)
                subViewProfile.addSubview(followButton)
                subViewProfile.addSubview(TotalFollowLabel)
                setupViewProfile()
            return subViewProfile
        
        }else {
            subView.backgroundColor = UIColor.themeHeaderColor()
            subView.addSubview(TracksLabel)
            subView.addSubview(shuffleButton)
            setupViewAction()
            return subView
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ArtistTrackCell
            cell.song = self.songs[indexPath.row]
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.backgroundColor = .white
            return cell
    }
    
}


