import Foundation
import UIKit
import FBSDKLoginKit
import SDWebImage
import GoogleSignIn


class MyProfileController: UITableViewController {
    
    static var sharedController = MyProfileController()
    
    var data = [(name:"Version", image:"info")]
    
    // personal
    var dataPer = [
        (name:"My Music", image:"playlist-1"),
        (name:"History", image:"history-1"),
        (name:"Available Offline", image:"downloading")
    ]
    
    var planType = "Unknown"
    
    var url: String = "mobile/subscribe/payment-information"
    
    fileprivate let cellId = "cellId"
    fileprivate let cellProfileId = "cellProfileId"
    fileprivate let cellLogoutId = "cellLogoutId"
    fileprivate let cellPeronalId = "cellPeronalId"
    fileprivate let cellNotifiId = "cellNotifiId"
    
    private func setupView(){
        
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView?.register(ProfileCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(ProfileUserCell.self, forCellReuseIdentifier: cellProfileId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellLogoutId)
        tableView?.register(ProfilePersnalCell.self, forCellReuseIdentifier: cellPeronalId)
        tableView?.register(ProfileSubscriptionCell.self, forCellReuseIdentifier: cellNotifiId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    var myProfile: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyProfileController.sharedController = self
        setupView()
        onHandleGetPayment()
        MusicPlayer.sharedInstance.myProfileController = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "My Profile"
        myProfile = (UserDefaults.standard.value(forKey: "userAuth") as? [String: Any])!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "Back"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func isOffline() -> Bool {
        return UserDefaults.standard.isOffline()
    }
    // MARK: - Table view data source
    
    func onHandleLogot() {
        let actionSheetController: UIAlertController = UIAlertController(title: "Are you sure want to log out?", message: nil, preferredStyle: .actionSheet)
        
        let firstAction: UIAlertAction = UIAlertAction(title: "Logout", style: .default) { action -> Void in
            self.onHandleShowLogin()
        }
        firstAction.setValue(UIColor.themeBaseColor(), forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(cancelAction)

        
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        actionSheetController.show()
    }
    
    func onHandleShowLogin(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        LoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        MusicPlayer.sharedInstance.audioPlayer?.pause()
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func onHandleGetPayment(){
        SubscriptionService.onHandleGetPayment(url, { (subscription) in
            DispatchQueue.main.async {
                
                self.planType = (subscription?.name)!
                self.tableView.reloadData()
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                // AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }
        })
    }
    
    
    
}



extension MyProfileController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return 90
        }else {
            return 55
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fView = UIView()
        return fView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        else if section == 1{
            return dataPer.count
        }
        else if section == 2 {
            return data.count
        } else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let userProfileController = UserProfileController()
            userProfileController.title = self.myProfile["name"] as? String
            navigationController?.pushViewController(userProfileController, animated: true)
        }
        else if indexPath.section == 3{
            onHandleLogot()
        }else if indexPath.section == 1{
            
            if indexPath.row == 0{
                if isOffline() {
                    DispatchQueue.main.async {
                        AppStateHelper.shared.onHandleAlertNotifiError(title: "Sorry, you are in offline mode.")
                    }
                }else {
                    let myPlaylistController = MyMusicController()
                    navigationController?.pushViewController(myPlaylistController, animated: true)
                }
            }else if indexPath.row == 1{
                if isOffline() {
                    DispatchQueue.main.async {
                        AppStateHelper.shared.onHandleAlertNotifiError(title: "Sorry, you are in offline mode.")
                    }
                }else {
                    let historyController = HistoryController()
                    historyController.title = "History"
                    navigationController?.pushViewController(historyController, animated: true)
                }
            }else if indexPath.row == 2 {
                let downloadManagerController = DownloadManagerController()
                downloadManagerController.navigationItem.title = "Available Offline"
                navigationController?.pushViewController(downloadManagerController, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellProfileId, for: indexPath) as! ProfileUserCell
            DispatchQueue.main.async {
                cell.imageView?.sd_setImage(with: URL(string: (self.myProfile["profile"] as? String)!), placeholderImage: UIImage(named: "avatar"))
                cell.textLabel?.text = self.myProfile["name"] as? String
            }
            cell.accessoryType = .disclosureIndicator
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            return cell
        }
        else if (indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: cellPeronalId, for: indexPath) as! ProfilePersnalCell
            DispatchQueue.main.async {
                cell.ImageView.image = UIImage(named: self.dataPer[indexPath.row].image)
                cell.titleLabel.text = self.dataPer[indexPath.row].name
            }
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.accessoryType = .disclosureIndicator
            return cell
            
        } else if indexPath.section == 2{
            
            let cell = ProfileCell.init(style: .value1, reuseIdentifier: cellId)
            DispatchQueue.main.async {
                cell.ImageView.image = UIImage(named: self.data[indexPath.row].image)
                cell.titleLabel.text = self.data[indexPath.row].name
                cell.accessoryType = .disclosureIndicator
                cell.accessoryType = .none
                cell.subLabel.text = Bundle.main.releaseVersionNumber
                cell.subLabel.textColor = .lightGray
            }
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellLogoutId, for: indexPath)
            DispatchQueue.main.async {
                cell.textLabel?.text = "Logout"
                cell.textLabel?.textColor = UIColor.themeBaseColor()
                cell.textLabel?.textAlignment = .center
            }
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            return cell
        }
        
    }
}


