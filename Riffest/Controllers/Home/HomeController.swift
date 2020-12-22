import Foundation
import UIKit
import MediaPlayer
import AVFoundation

class HomeController: UITableViewController, SliderDelegate{
    
    var headerTitle = ["","Best of the Week","Genres","New Release", "Top Artists","The Best Playlists"]

    fileprivate let cellId = "cellId"
    fileprivate let cellTopId = "cellTopId"
    fileprivate let browseCellId = "browseCellId"
    fileprivate let releaseCellId = "releaseCellId"
    fileprivate let artistCellId = "artistCellId"
    fileprivate let featuredCellId = "featuredCellId"

    
    public static var sharedController = HomeController()
    
    let sliderUIView = UIView()
    var slider: SliderViews?
    
    private func setupView(){
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellTopId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: browseCellId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: releaseCellId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: artistCellId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: featuredCellId)

        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        sliderUIView.frame = CGRect(x:0,y:0, width: self.view.bounds.width, height: 200)
        slider?.frame = CGRect(x:0,y:0, width: self.view.bounds.width, height: 200)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white
        HomeController.sharedController = self
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Discover"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // func slider
    func sbslider(_ sbslider: SliderViews, didTapOn targetImage: UIImage, andParentView targetView: UIImageView) {
        let photoViewerManager = PhotoManager()
        photoViewerManager.initializePhotoViewer(fromViewControlller: self, forTargetImageView: targetView, withPosition: sbslider.frame)
    }

    
    func onHandleGoToArtist(artistSong: RMSong){
        let artistMusicController = ArtistMusicController()
        artistMusicController.artistSong = artistSong
        navigationController?.pushViewController(artistMusicController, animated: true)
    }
    func onHandleGoToAlbum(albumSong: RMSong){
        let albumSingleController = AlbumSingleController()
        albumSingleController.albumSong = albumSong
        navigationController?.pushViewController(albumSingleController, animated: true)
    }

    @objc func handleInterruption(notification: NSNotification) {
        guard let value = (notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber)?.uintValue,
            let interruptionType =  AVAudioSession.InterruptionType(rawValue: value) else {
                return
        }
        switch interruptionType {
        case .began:
            print("stop====")
            MusicPlayer.sharedInstance.audioPlayer?.pause()
            break 
        case .ended:
            MusicPlayer.sharedInstance.audioPlayer?.resume()
            print("resume====")
            break
        }
    }
    
}

extension  HomeController{
    
    @objc func onHandleSeeMore(sender: UIButton!) {
        if sender.tag == 1 {
            onHandleGoToTopThisWeek()
        } else if sender.tag == 2 {
            onHandleGoToGenre()
        } else if sender.tag ==  3 {
           onHandleGoToRelase()
        } else if sender.tag == 4 {
            onHandleGotoTopArtist()
        }else if sender.tag == 5 {
            onHandleGotoPlaylist()
        }
    }
    
    func onHandleGoToPlaylistFeature(playlist: [RMMyPlaylist], indexPath: Int){
        let playlistSingleController = FeaturedPlaylistSingleController()
        playlistSingleController.playlists = playlist
        playlistSingleController.currentIndex = indexPath
        navigationController?.pushViewController(playlistSingleController, animated: true)
    }
    

    func onHandleGotoPlaylist(){
        let theBestPlaylistController = TheBestPlaylistController()
        theBestPlaylistController.title = "The Best Playlists"
        navigationController?.pushViewController(theBestPlaylistController, animated: true)
    }
    
    func onHandleGotoTopArtist(){
        let topArtistController = TopArtistController()
        topArtistController.title = "Top Artists"
        navigationController?.pushViewController(topArtistController, animated: true)
    }
    func onHandleGoToRelase(){
        let releaseController = ReleaseController()
        releaseController.title = "New Release"
        navigationController?.pushViewController(releaseController, animated: true)
    }
    func onHandleGoToTopThisWeek(){
        let topThisWeekController = TopThisWeekController()
        topThisWeekController.title = "Best of the Week"
        navigationController?.pushViewController(topThisWeekController, animated: true)
    }
    func onHandleGoToGenre(){
        let genreViewController = GenreViewController()
        genreViewController.title = "Genres"
        navigationController?.pushViewController(genreViewController, animated: true)
    }
    
    func onHandleReload(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeController{
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 0 {
            return 200
        } else if indexPath.section == 2{
            return 170
        }else {
            return 190
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subView = UIView()
        let label = UILabel()
        subView.backgroundColor = UIColor.themeHeaderColor()
        label.text = headerTitle[section]
        label.font = AppStateHelper.shared.defaultFontRegular(size:18)
      //  label.textColor = .white
        subView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.leftAnchor.constraint(equalTo: subView.leftAnchor,constant: 15).isActive = true
        if section != 0 {
            let button = UIButton()
            button.setTitleColor(UIColor.themeBaseColor(), for: UIControl.State())
            button.titleLabel?.font = AppStateHelper.shared.defaultFontRegular(size:15)
            button.setTitle("See All >", for: .normal)
            button.alpha = 1.0
            button.tag = section
            button.addTarget(self, action: #selector(onHandleSeeMore), for: .touchUpInside)
            subView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 70).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.rightAnchor.constraint(equalTo: subView.rightAnchor, constant: -10 ).isActive = true
        }
        return subView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 42
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return headerTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            DispatchQueue.main.async {
                self.slider = SliderViews.sharedController
                self.slider?.delegate = self
                cell.addSubview(self.sliderUIView)
                self.sliderUIView.addSubview(self.slider!)
            }
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTopId, for: indexPath)
            let controller = TopController.sharedController
            addChild(controller)
            controller.didMove(toParent: self)
            cell.addSubview(controller.view)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: browseCellId, for: indexPath)
            let controller = GenreController.sharedController
            addChild(controller)
            cell.addSubview(controller.view)
            controller.didMove(toParent: self)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: releaseCellId, for: indexPath)
            let controller = NewReleaseController.sharedController
            addChild(controller)
            controller.didMove(toParent: self)
            cell.addSubview(controller.view)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: artistCellId, for: indexPath)
            let controller = PopularArtistController.sharedController
            addChild(controller)
            controller.didMove(toParent: self)
            cell.addSubview(controller.view)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
        }else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: featuredCellId, for: indexPath)
            let controller = FeaturedPlaylistController.sharedController
            addChild(controller)
            controller.didMove(toParent: self)
            cell.addSubview(controller.view)
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.selectionStyle = .none
            return cell
            
        }
     }
 
}
