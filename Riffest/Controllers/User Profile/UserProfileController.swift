import Foundation
import UIKit

class UserProfileController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    static var sharedController = UserProfileController()
    
    var data = ["Name","Email","Member since"]
    
    fileprivate let cellProfileId = "cellProfileId"
    fileprivate let cellId = "cellId"
    var myProfile: [String: Any] = [:]
    var imageBackground: UIImageView?
    var profileVIewContainer = UIView()

    var tableView: UITableView?

    private func setupView(){
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView = UITableView(frame: self.view.bounds)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        tableView?.register(UserProfileCell.self, forCellReuseIdentifier: cellProfileId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.separatorStyle = .none
        tableView?.tableFooterView = UIView(frame: .zero)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = .clear
        tableView?.separatorStyle = .singleLine
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 130))
        if UIDevice().userInterfaceIdiom == .pad {
            let explanationLabel = UILabel(frame: CGRect(x:50, y: 0, width: view.frame.size.width - 150, height: 60))
            explanationLabel.textColor = UIColor.lightGray
            explanationLabel.numberOfLines = 3
            explanationLabel.font = AppStateHelper.shared.defaultFontRegular(size: 14)
            explanationLabel.text = "If you wish change name, email and profile it's simply just update on your social media account and then login again."
            footerView.addSubview(explanationLabel)
        }else{
            let explanationLabel = UILabel(frame: CGRect(x:15, y: 0, width: view.frame.size.width - 20, height: 60))
            explanationLabel.textColor = UIColor.lightGray
            explanationLabel.numberOfLines = 3
            explanationLabel.font = AppStateHelper.shared.defaultFontRegular(size: 14)
            explanationLabel.text = "If you wish change name, email and profile it's simply just update on your social media account and then login again."
            footerView.addSubview(explanationLabel)
        }
        tableView?.tableFooterView = footerView

    }
    func setupImageBackground() {
        self.imageBackground = UIImageView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 270))
        profileVIewContainer =  UIView(frame: CGRect(x:0,y:0, width: self.view.frame.size.width, height: 270))
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
        UserProfileController.sharedController = self
        self.view.backgroundColor = .white
        setupImageBackground()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myProfile = (UserDefaults.standard.value(forKey: "userAuth") as? [String: Any])!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UserProfileController {
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        DispatchQueue.main.async {
            self.imageBackground?.frame.size.height = -offsetY + 270
            self.profileVIewContainer.frame.size.height = -offsetY + 270
        }
    }
}

extension UserProfileController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return 270
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else{
            return 3
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellProfileId, for: indexPath) as! UserProfileCell
            DispatchQueue.main.async {
                cell.ImageView.sd_setImage(with: URL(string: (self.myProfile["profile"] as? String)!), placeholderImage: UIImage(named: "avatar"))
               cell.NameLabel.text = self.myProfile["name"] as? String
               cell.IdLabel.text = "ID: \(self.myProfile["id"] ?? 0)"
            }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1,
                                       reuseIdentifier: cellId)
            DispatchQueue.main.async {
                cell.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size: 16)
                cell.textLabel?.text =  self.data[indexPath.row]
                if indexPath.row == 0 {
                    cell.detailTextLabel?.text = self.myProfile["name"] as? String
                }else if indexPath.row == 1 {
                    cell.detailTextLabel?.text = self.myProfile["email"] as? String
                }else {
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "MMM dd, yyyy"
                    let date: NSDate? = dateFormatterGet.date(from: (self.myProfile["created_at"] as? String)!)! as NSDate
                    cell.detailTextLabel?.text = dateFormatterPrint.string(from: date! as Date)
                }
            }
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            return cell
        }
     }
 
}
