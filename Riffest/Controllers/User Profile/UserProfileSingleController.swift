import Foundation
import UIKit

class UserProfileSingleController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    static var sharedController = UserProfileSingleController()
    
    fileprivate let cellProfileId = "cellProfileId"
    fileprivate let cellId = "cellId"
    
    var myProfile: [String: Any] = [:]
    var imageBackground: UIImageView?
    var profileVIewContainer = UIView()
    
    var tableView: UITableView?
    
    private func setupView(){
        tableView = UITableView(frame: self.view.bounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        tableView?.register(UserProfileSingleCell.self, forCellReuseIdentifier: cellProfileId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.separatorStyle = .none
        tableView?.tableFooterView = UIView(frame: .zero)
        tableView?.backgroundColor = .clear
        tableView?.separatorStyle = .singleLine
    }
    func setupImageBackground() {
        self.imageBackground = UIImageView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 250))
        profileVIewContainer =  UIView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 250))
        profileVIewContainer.backgroundColor = UIColor.themeBaseBgColor()
        self.imageBackground?.image = UIImage(named: "LaunchScreen")
        self.imageBackground?.contentMode = .scaleAspectFill
        self.imageBackground?.clipsToBounds = true
        self.view.addSubview(imageBackground!)
        self.view.addSubview(profileVIewContainer)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserProfileSingleController.sharedController = self
        self.view.backgroundColor = .white
        setupImageBackground()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myProfile = (UserDefaults.standard.value(forKey: "userAuth") as? [String: Any])!
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.themeBaseColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UserProfileSingleController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        DispatchQueue.main.async {
            self.imageBackground?.frame.size.height = -offsetY + 250
            self.profileVIewContainer.frame.size.height = -offsetY + 250
        }
    }
}

extension UserProfileSingleController {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return 250
        }else{
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellProfileId, for: indexPath) as! UserProfileSingleCell
            DispatchQueue.main.async {
                cell.ImageView.sd_setImage(with: URL(string: (self.myProfile["profile"] as? String)!), placeholderImage: UIImage(named: "avatar"))
                cell.NameLabel.text = self.myProfile["name"] as? String
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            let controller = UserProfileListController.sharedController
            addChild(controller)
            controller.didMove(toParent: self)
            cell.addSubview(controller.view)
            cell.separatorInset = .zero
            cell.selectionStyle = .none
            cell.layoutMargins = .zero
            return cell
        }
    }
    
}
