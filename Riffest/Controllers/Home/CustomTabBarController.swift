import Foundation
import UIKit
import CRNotifications
import MediaPlayer
import StreamingKit
import MarqueeLabel

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "LaunchScreen")
        iv.clipsToBounds = true
        return iv
    }()
    var url: String = "mobile/home"

    
    var showPrimary = false
    var songs: [RMSong] = []
    var indexPlaying: Int = 0
    // set up view
    let playerView = UIView()
    let artistProfile = UIImageView()
    let songTitle = UILabel()
    
    let CoverView: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.layer.shadowOffset = CGSize.zero
        vw.layer.shadowOpacity = 0.6
        vw.layer.shadowRadius = 5
        return vw
    }()
    
    lazy var btnNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.themeBaseColor(), for: .focused)
        button.tintColor = .black
       button.addTarget(self, action: #selector(nextPlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var btnPlayOrPause: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.themeBaseColor(), for: .focused)
        button.tintColor = .black
        button.addTarget(self, action: #selector(playerOrPause), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var indicatorView = UIActivityIndicatorView()
    lazy var progressView: CustomProgressTopUISlider = {
        let progress = CustomProgressTopUISlider()
        progress.minimumValue = 0
        progress.maximumValue = 100
        progress.isContinuous = true
        progress.addTarget(self,action: #selector(paybackSliderValueDidChange),for: .valueChanged)
        progress.isUserInteractionEnabled = true
        progress.setThumbImage(UIImage(named: "progress"), for: .highlighted)
        progress.setThumbImage(UIImage(named: "circle"), for: .normal)
        progress.minimumTrackTintColor = UIColor.themeBaseColor()
        progress.maximumTrackTintColor = UIColor.themeHeaderColor()
        return progress
    }()
    fileprivate func setupView() {
        view.addSubview(playerView)
        playerView.addSubview(CoverView)
        CoverView.addSubview(artistProfile)
        playerView.addSubview(songTitle)
        playerView.addSubview(btnNext)
        playerView.addSubview(btnPlayOrPause)
        playerView.addSubview(indicatorView)
        
        playerView.isHidden = true
        playerView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leftAnchor.constraint(equalTo: self.playerView.leftAnchor).isActive = true
        progressView.rightAnchor.constraint(equalTo: self.playerView.rightAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: self.playerView.topAnchor).isActive = true
        playerView.backgroundColor = .white
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.layer.shadowOpacity = 0.1
        playerView.layer.shadowOffset = CGSize.zero
        playerView.layer.shadowRadius = 1
        
        
        CoverView.leftAnchor.constraint(equalTo: self.playerView.leftAnchor, constant: 15).isActive = true
        CoverView.topAnchor.constraint(equalTo: self.playerView.topAnchor, constant: 14).isActive = true
        CoverView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        CoverView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        artistProfile.image = UIImage(named: "thumbnail")
        artistProfile.layer.cornerRadius = 4
        artistProfile.layer.masksToBounds = true
        artistProfile.translatesAutoresizingMaskIntoConstraints = false
        artistProfile.widthAnchor.constraint(equalToConstant: 40).isActive = true
        artistProfile.heightAnchor.constraint(equalToConstant: 40).isActive = true
        artistProfile.leftAnchor.constraint(equalTo: self.playerView.leftAnchor, constant: 15).isActive = true
        artistProfile.topAnchor.constraint(equalTo: self.playerView.topAnchor, constant: 14).isActive = true
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(handlePlayer))
       tapOnImage.numberOfTapsRequired = 1
        artistProfile.isUserInteractionEnabled = true
        artistProfile.addGestureRecognizer(tapOnImage)
        
        btnNext.setImage( UIImage.init(named: "next-forward"), for: .normal)
        btnPlayOrPause.setImage( UIImage.init(named: "play"), for: .normal)
        
        btnPlayOrPause.translatesAutoresizingMaskIntoConstraints = false
        btnPlayOrPause.centerYAnchor.constraint(equalTo: self.playerView.centerYAnchor).isActive = true
        btnPlayOrPause.rightAnchor.constraint(equalTo: self.playerView.rightAnchor, constant:-70).isActive = true
        btnPlayOrPause.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnPlayOrPause.heightAnchor.constraint(equalToConstant: 25).isActive = true

        btnNext.translatesAutoresizingMaskIntoConstraints = false
        btnNext.centerYAnchor.constraint(equalTo: self.playerView.centerYAnchor).isActive = true
        btnNext.rightAnchor.constraint(equalTo: self.playerView.rightAnchor, constant: -20).isActive = true
        btnNext.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnNext.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        songTitle.translatesAutoresizingMaskIntoConstraints = false
        songTitle.centerYAnchor.constraint(equalTo: self.playerView.centerYAnchor).isActive = true
        songTitle.leftAnchor.constraint(equalTo: self.artistProfile.leftAnchor, constant: 50).isActive = true
        
        songTitle.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 160).isActive = true
        songTitle.heightAnchor.constraint(equalToConstant: 45).isActive = true
        songTitle.font = AppStateHelper.shared.defaultFontRegular(size: 16)
        
        if UIDevice().userInterfaceIdiom == .phone {
            print(UIScreen.main.nativeBounds.height)
            if UIScreen.main.nativeBounds.height >= 2436 {
                playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -82).isActive = true
            }
            else {
                playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -49).isActive = true
            }
        } else if UIDevice().userInterfaceIdiom == .pad {
            playerView.safeAreaBottomAnchor.constraint(equalTo: self.view.safeAreaBottomAnchor, constant: -49).isActive = true
        }
        playerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        playerView.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = UIColor.themeBaseColor()
        indicatorView.centerYAnchor.constraint(equalTo: self.playerView.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: self.playerView.centerXAnchor).isActive = true
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        imageView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      
    }
    fileprivate func isOffline() -> Bool {
        return UserDefaults.standard.isOffline()
    }
    
   @objc  func setupTabBar() {
    
        let homeNavigationController = UINavigationController(rootViewController: HomeController())
        homeNavigationController.title = "Home"
        homeNavigationController.tabBarItem.image = UIImage(named: "library")
        
     //   let myMusicController = UINavigationController(rootViewController: MyMusicController())
        let myMusicController = UINavigationController(rootViewController: MyPlaylistController())
        myMusicController.title = "My Playlists"
        myMusicController.tabBarItem.image = UIImage(named: "mymusic")
        
        let myProfileNavController = UINavigationController(rootViewController: MyProfileController())
        myProfileNavController.title = "My Profile"
        myProfileNavController.tabBarItem.image = UIImage(named: "profile")
        
        let searchNavController = UINavigationController(rootViewController: SearchController())
        searchNavController.title = "Search"
        searchNavController.tabBarItem.image = UIImage(named: "search")
        
        let moreNavController = UINavigationController(rootViewController: MoreController())
        moreNavController.title = "More"
        moreNavController.tabBarItem.image = UIImage(named: "more")
    
        viewControllers = [homeNavigationController, myMusicController, myProfileNavController, searchNavController,moreNavController]
    }
    
     func switchTabBarOffline() {
        if isOffline() {
            viewControllers?.remove(at: 0)
        }else {
            let homeNavigationController = UINavigationController(rootViewController: HomeController())
            homeNavigationController.title = "Home"
            homeNavigationController.tabBarItem.image = UIImage(named: "library")
            viewControllers?.insert(homeNavigationController, at: 0)
            
            let searchNavController = UINavigationController(rootViewController: SearchController())
            searchNavController.title = "Search"
            searchNavController.tabBarItem.image = UIImage(named: "search")
            viewControllers?.insert(searchNavController, at: 3)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.addSubview(imageView)
        if !isLoggedIn() {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }else{
            onHandleRequestData()
        }
        MusicPlayer.sharedInstance.customTabBarController = self
        AppStateHelper.shared.customTabBarController = self
        MoreController.sharedController.customTabBarController = self
        self.setupTabBar()
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(229, green: 231, blue: 235, alpha: 1).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        UITabBar.appearance().tintColor = UIColor.themeBaseColor()
        tabBar.isTranslucent = false
        view.addSubview(playerView)
        setupView()
        AppStateHelper.shared.checkNetwork()
    }
    func onHandleRequestData(){
        DispatchQueue.main.async {
            AppStateHelper.shared.onHandleShowIndicator()
        }
        RMService.onHandleGetData(url,{ (featured,top, genre,relase,artist, playlist) in
            DispatchQueue.main.async {
                
                HomeController.sharedController.onHandleReload()
                self.onHandleHideLaunch()
                
                AppStateHelper.shared.onHandleHideIndicator()
                LoginController.sharedController.finishLoggingIn()
                
                SliderViews.sharedController.createSlider(withImages: featured, withAutoScroll: true, in:
                    HomeController.sharedController.sliderUIView)
                TopController.sharedController.onHandleReload(song: top)
                GenreController.sharedController.onHandleReload(genre: genre)
                NewReleaseController.sharedController.onHandleReload(song: relase)
                PopularArtistController.sharedController.onHandleReload(artist: artist)
                FeaturedPlaylistController.sharedController.onHandleReload(playlist: playlist)
                UserDefaults.standard.setIsOffline(value: false)
                
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                AppStateHelper.shared.onHandleHideIndicator()
                UserDefaults.standard.setIsOffline(value: true)
                LoginController.sharedController.finishLoggingIn()
                self.switchTabBarOffline()
                self.onHandleHideLaunch()
                self.selectedIndex = 1
            }
        })
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    
    @objc func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    func onHandleAlertNotifi(title:String){
        CRNotifications.showNotification(type: CRNotifications.success,  title:"Riffest", message: title, dismissDelay: 3, completion: {
        })
    }
    func onHandleAlertNotifiError(title:String){
        CRNotifications.showNotification(type: CRNotifications.error,  title:"Riffest", message: title, dismissDelay: 3, completion: {
        })
    }
    
    func onHandleHideLaunch(){
        DispatchQueue.main.async {
            self.imageView.isHidden = true
        }
    }

}

extension CustomTabBarController {
    
    func handeSetUpPlayer(){
        
        playMusiceAt(indexPath: indexPlaying)
        MusicPlayer.sharedInstance.setupNowPlayingInfoCenter()
    }
    func playMusiceAt(indexPath:Int){
        MusicPlayer.sharedInstance.lastIndex = songs.count
        MusicPlayer.sharedInstance.queue = songs
        MusicPlayer.sharedInstance.changeTrack(atIndex: indexPath, completion: nil)
    }
    func updateViewWithSongData(snogIndex: Int) {
        DispatchQueue.main.async {
            self.progressView.value = 0
            self.songTitle.text = self.songs[snogIndex].title!
            self.artistProfile.sd_setImage(with: URL(string: self.songs[snogIndex].poster!)!, placeholderImage: UIImage(named: "thumbnail"))
            let color: UIColor = self.artistProfile.image!.getPixelColor(pos: CGPoint(x:2.0,y:3.0))
            self.CoverView.layer.shadowColor = color.cgColor
        }
    }
    @objc func playerOrPause(){
        if  MusicPlayer.sharedInstance.audioPlayer?.state == STKAudioPlayerState.playing {
            MusicPlayer.sharedInstance.audioPlayer?.pause()
            btnPlayOrPause.setImage( UIImage.init(named: "play"), for: .normal)
        }else if  MusicPlayer.sharedInstance.audioPlayer?.state == STKAudioPlayerState.paused {
            MusicPlayer.sharedInstance.audioPlayer?.resume()
            btnPlayOrPause.setImage( UIImage.init(named: "pause"), for: .normal)
        }
    }
    @objc func nextPlay(){
        MusicPlayer.sharedInstance.next(completion: self.handleCompletion())
    }
    
    func setUpShowPlayer(){
        if showPrimary == false{
            showPrimary = true
            playerView.slideInFromTop()
            playerView.isHidden = false
        }
    }
   
    @objc func paybackSliderValueDidChange(sender: UISlider!){
        MusicPlayer.sharedInstance.seekToTime(sliderValue: Double(sender.value))
    }
    @objc func handlePlayer(){
        let playerController = PlayerController()
        playerController.songs = songs
        playerController.indexPlaying = indexPlaying
        playerController.onHandleChangeUIView(songIndex: indexPlaying)
        present(playerController, animated: true, completion: nil)
    }
    
    // if use did not subscription
    @objc func onHandleChoosePlan(){
        let navChoosePlanController = UINavigationController(rootViewController: ChoosePlanController())
        present(navChoosePlanController, animated: true, completion: nil)
    }
    
    func handleCompletion() -> (_ error: NSError) -> Void {
        return { error in
            DispatchQueue.main.async {
                 AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }
        }
    }
    
}

