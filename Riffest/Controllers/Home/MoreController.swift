import UIKit
import CTFeedbackSwift


class MoreController: UITableViewController {
    
    
    var customTabBarController: CustomTabBarController?
    public static var sharedController = MoreController()

    fileprivate let cellId = "cellId"
    fileprivate let celSettinglId = "celSettinglId"

    var data = [
            (name:"Helps and Support", image:"feedback"),
            (name:"Riffest FAQ", image:"ask"),
            (name:"About Us", image:"about-us")
        ]
    var dataSettings = [(name:"Offline mode", image:"online")]
    
    lazy var switchTheme: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.addTarget(self, action: #selector(SwitchDarkThem), for: .valueChanged)
        return switchView
    }()
    
    lazy var switchOnline: UISwitch = {
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.addTarget(self, action: #selector(SwitchValueChanged), for: .valueChanged)
        return switchView
    }()
    
    
    private func setupView(){
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: celSettinglId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoreController.sharedController = self
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "More"
        switchTheme.isOn = isOffline()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    fileprivate func isOffline() -> Bool {
        return UserDefaults.standard.isOffline()
    }
    @objc func SwitchDarkThem(){
        DispatchQueue.main.async {
            self.switchTheme.isOn = false
        }
        let alertController = UIAlertController(title: "Riffest", message: "This feature is temporality unavailable.", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
           
        }
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func SwitchValueChanged(){
        if AppStateHelper.shared.notReachable {
            DispatchQueue.main.async {
                AppStateHelper.shared.onHandleAlertNotifiError(title: "No internet connection. Please turn on Cellular Data or Wi-Fi and try again.")
                self.switchOnline.isOn = true
            }
            return
        }
        if isOffline() {
             UserDefaults.standard.setIsOffline(value: false)
             DispatchQueue.main.async {
                self.switchOnline.isOn = self.isOffline()
             }
             (self.tabBarController as? CustomTabBarController)?.switchTabBarOffline()
             (self.tabBarController as? CustomTabBarController)?.onHandleRequestData()
        }else {
            let alertController = UIAlertController(title: "Go Offline", message: "Only the content you're saved to storage or downloaded to device will be playable.", preferredStyle: .alert)
        
            let actionOk = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                UserDefaults.standard.setIsOffline(value: true)
                self.switchOnline.isOn = self.isOffline()
                (self.tabBarController as? CustomTabBarController)?.switchTabBarOffline()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                self.switchOnline.isOn = self.isOffline()
            }
            alertController.addAction(actionOk)
            alertController.addAction(actionCancel)
            self.present(alertController, animated: true, completion: nil)
      }
      
    }
}

extension MoreController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let explanationLabel = UILabel(frame: CGRect(x:10, y: 0, width: view.frame.size.width - 20, height: 50))
        explanationLabel.textColor = UIColor.gray
        explanationLabel.numberOfLines = 2
        explanationLabel.font = AppStateHelper.shared.defaultFontRegular(size: 14)
        explanationLabel.text = "Only the content you're saved to storage to device will be playable."
        footerView.addSubview(explanationLabel)
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {

        }else {
            if indexPath.row == 0{
                if isOffline() {
                    DispatchQueue.main.async {
                        AppStateHelper.shared.onHandleAlertNotifiError(title: "Sorry, you are in offline mode.")
                    }
                }else {
                    let configuration = FeedbackConfiguration(toRecipients: ["riffest@bachle.vn"], usesHTML: true)
                    let controller = FeedbackViewController(configuration: configuration)
                    controller.title = "Helps and Support"
                    navigationController?.pushViewController(controller, animated: true)
                }
            }else if indexPath.row == 1{
                if isOffline() {
                    DispatchQueue.main.async {
                        AppStateHelper.shared.onHandleAlertNotifiError(title: "Sorry, you are in offline mode.")
                    }
                }else {
                    let pagesController = PagesController()
                    pagesController.urlString = "pages/4"
                    pagesController.navigationItem.title = "Riffest FAQ"
                    navigationController?.pushViewController(pagesController, animated: true)
                }
            }
            else if indexPath.row == 2{
                if isOffline() {
                    DispatchQueue.main.async {
                        AppStateHelper.shared.onHandleAlertNotifiError(title: "Sorry, you are in offline mode.")
                    }
                }else {
                    let pagesController = PagesController()
                    pagesController.urlString = "pages/5"
                    pagesController.navigationItem.title = "About Us"
                    navigationController?.pushViewController(pagesController, animated: true)
                }
             
            }
        }
      

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return dataSettings.count
        } else {
            return data.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = dataSettings[indexPath.row].name
            cell.imageView?.image = UIImage(named: dataSettings[indexPath.row].image)
            cell.addSubview(switchOnline)
            switchOnline.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            switchOnline.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -15).isActive = true
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size: 16)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            cell.textLabel?.text = data[indexPath.row].name
            cell.imageView?.image = UIImage(named: data[indexPath.row].image)
            cell.accessoryType = .disclosureIndicator
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size: 16)
            return cell
        }
        
       
    }
    
}
