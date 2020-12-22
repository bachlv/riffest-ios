import Foundation
import UIKit
import CarbonKit

//MMarked: CustomBarButtonItem to add selfType Property
class CustomBarButtonItem:UIBarButtonItem{
    var selfType:WhatVC?
    var isEditting:Bool = false
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
@objc enum WhatVC:Int {
    case downloading,downloaded
}


class DownloadManagerController: UIViewController, CarbonTabSwipeNavigationDelegate{
    
    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    fileprivate func setupView() {
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        let color: UIColor = UIColor.themeHeaderColor()
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.themeBaseColor())
        
        carbonTabSwipeNavigation.setIndicatorHeight(5)
        carbonTabSwipeNavigation.setTabExtraWidth(0)
        carbonTabSwipeNavigation.setTabBarHeight(45)
        carbonTabSwipeNavigation.currentTabIndex = 1
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.view.bounds.width/2, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(self.view.bounds.width/2, forSegmentAt: 1)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(1.0))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.themeBaseColor(), font: AppStateHelper.shared.defaultFontRegular(size: 16))
        carbonTabSwipeNavigation.setNormalColor(UIColor.black, font: AppStateHelper.shared.defaultFontRegular(size: 16))
        carbonTabSwipeNavigation.toolbar.barTintColor = color
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        items = ["Downloading","Downloaded"]
        self.view.backgroundColor = .white
        setupView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            return DownloadingController.sharedController
        default:
            return DownloadedController.sharedController
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        self.title = items[Int(index)] as? String
        switch index {
        case 0:
            let editListButton = CustomBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onHandleEditList))
            editListButton.selfType = .downloading
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.themeHeaderColor()
            navigationItem.rightBarButtonItems = [editListButton].reversed()
            break
        default:
            let editListButton = CustomBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onHandleEditList))
            editListButton.selfType = .downloaded
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.themeBaseColor()
            navigationItem.rightBarButtonItems = [editListButton].reversed()
            break
        }
    }
    
    fileprivate func updateCurrentButton(_ sender:CustomBarButtonItem, _ who: WhatVC){
        if sender.isEditting == false {
            if sender.selfType ==  .downloaded {
                DownloadedController.sharedController.editCommand()
            } else if sender.selfType ==  .downloading {
                DownloadingController.sharedController.editCommand()
            }
            self.changeBarbuttonTitle(sender, "Done")
            sender.isEditting = true
        }else{
            if sender.selfType ==  .downloaded {
                DownloadedController.sharedController.doneCommand()
            }
            else if sender.selfType ==  .downloading {
                DownloadingController.sharedController.doneCommand()
            }
            self.changeBarbuttonTitle(sender, "Edit")
            sender.isEditting = false
        }
    }
    fileprivate func changeBarbuttonTitle(_ sender:CustomBarButtonItem , _ title:String){
        sender.title = title
    }
    @objc func onHandleEditList(sender:CustomBarButtonItem){
        if sender.selfType == .downloaded{
            self.updateCurrentButton(sender, .downloaded)
        }else if sender.selfType == .downloading {
            self.updateCurrentButton(sender, .downloading)
        }
    }
    
}
