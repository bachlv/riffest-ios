import Foundation
import UIKit
import CarbonKit

class MyMusicController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    public static var sharedController = MyMusicController()

    
    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var myProfile: [String: Any] = [:]

    fileprivate func setupViewNav() {
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        let color: UIColor = UIColor.themeHeaderColor()
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.themeBaseColor())
        carbonTabSwipeNavigation.setIndicatorHeight(5)
        carbonTabSwipeNavigation.setTabExtraWidth(0)
        carbonTabSwipeNavigation.setTabBarHeight(45)
        
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(70, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(70, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(70, forSegmentAt: 2)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(1.0))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.themeBaseColor(), font: AppStateHelper.shared.defaultFontRegular(size: 16))
        carbonTabSwipeNavigation.setNormalColor(UIColor.black, font: AppStateHelper.shared.defaultFontRegular(size: 16))
        carbonTabSwipeNavigation.toolbar.barTintColor = color
        
    }
    private func setupView(){
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        DispatchQueue.main.async {
            imageview.sd_setImage(with: URL(string: (self.myProfile["profile"] as? String)!), placeholderImage: UIImage(named: "avatar"))
            imageview.layer.borderWidth = 2
            imageview.layer.borderColor = UIColor.themeBaseColor().cgColor
        }
        imageview.contentMode = UIView.ContentMode.scaleAspectFit
        imageview.layer.cornerRadius = 17.5
        imageview.layer.masksToBounds = true
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(onHandleShowProfile))
        tapOnImage.numberOfTapsRequired = 1
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(tapOnImage)
        
        containView.addSubview(imageview)
        let rightBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MyMusicController.sharedController = self
        items = ["Albums","Artists","Playlists"]
        self.view.backgroundColor = .white
        setupView()
        setupViewNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myProfile = (UserDefaults.standard.value(forKey: "userAuth") as? [String: Any])!
        onHandleGetSong()
        self.navigationItem.title = "My Music"

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "Back"

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func onHandleShowProfile(){
        let userProfileController = UserProfileController()
        userProfileController.title = self.myProfile["name"] as? String
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    func onHandleGetSong(){
       // AppStateHelper.shared.onHandleShowIndicator()
        MyMusicService.onHandleGetMyMusic("mobile/mymusic",{ (song, artist, playlist, album) in
            DispatchQueue.main.async {
                ArtistController.sharedController.onHandleReload()
                FollowingPlaylistController.sharedController.onHandleReload()
                AlbumController.sharedController.onHandleReload()
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                 //AppStateHelper.shared.onHandleHideIndicator()
                 AppStateHelper.shared.onHandleAlertNotifiError(title: errorString.lowercased())
            }
        })
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
       // case 0:
           // return TrackController.sharedController
        case 0:
            return AlbumController.sharedController
        case 1:
            return ArtistController.sharedController
        default:
            return FollowingPlaylistController.sharedController
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        self.navigationItem.title = items[Int(index)] as? String
    }
    
}


