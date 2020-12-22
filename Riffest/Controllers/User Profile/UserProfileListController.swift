import Foundation
import UIKit

import Foundation
import UIKit
import CarbonKit

class UserProfileListController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    static var sharedController = UserProfileListController()

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
        
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(150, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(150, forSegmentAt: 1)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(1.0))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.themeBaseColor(), font: AppStateHelper.shared.defaultFontBold(size: 17))
        carbonTabSwipeNavigation.setNormalColor(UIColor.black, font: AppStateHelper.shared.defaultFontBold(size: 17))
        carbonTabSwipeNavigation.toolbar.barTintColor = color
        
    }
    private func setupView(){
//        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//        DispatchQueue.main.async {
//            imageview.sd_setImage(with: URL(string: (self.myProfile["profile"] as? String)!), placeholderImage: UIImage(named: "avatar"))
//            imageview.layer.borderWidth = 2
//            imageview.layer.borderColor = UIColor.themeBaseColor().cgColor
//        }
//        imageview.contentMode = UIViewContentMode.scaleAspectFit
//        imageview.layer.cornerRadius = 17.5
//        imageview.layer.masksToBounds = true
//        containView.addSubview(imageview)
//        let rightBarButton = UIBarButtonItem(customView: containView)
//        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserProfileListController.sharedController = self
        items = ["Recent Played","Playlists"]
        self.view.backgroundColor = .white
        setupView()
        setupViewNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myProfile = (UserDefaults.standard.value(forKey: "userAuth") as? [String: Any])!

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

extension UserProfileListController{
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            return RecentlyPlayedController.sharedController
        default:
            return UserPlaylistController.sharedController
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        self.navigationItem.title = items[Int(index)] as? String
    }
    
}

