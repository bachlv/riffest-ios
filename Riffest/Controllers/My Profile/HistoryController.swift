import Foundation
import UIKit

class HistoryController: UITableViewController {
    
    var songs: [RMSong] = []
    
    fileprivate let cellId = "cellId"
    public static var sharedController = HistoryController()
    var url: String = "mobile/user/history"
    var search = ""
    var next_page = 1
    var last_page = 0
    var selectedCells: [UITableViewCell] = []
    var valuesId:[Int] = []
    
    private func setupView(){
        tableView?.register(HistoryCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        
        let editListButton = CustomBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(onHandleEditList))
        self.navigationItem.rightBarButtonItem = editListButton
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryController.sharedController = self
        setupView()
        onHandleGetSong(next_page: next_page, search: search)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling:CGFloat = scrollView.contentOffset.y +   scrollView.frame.size.height
        if(endScrolling >= scrollView.contentSize.height){
            next_page = next_page + 1
            if last_page != 0  {
                DispatchQueue.main.async {
                    self.onHandleGetSong(next_page: self.next_page, search: self.search)
                }
            }
        }
    }
    func onHandleGetSong(next_page: Int, search: String){
        // we used the same files TopService we dont want to create more because it is the same
        UserService.onHandleGetSongById(url,next_page,search, { (song) in
            self.last_page = song.count
            DispatchQueue.main.async {
                self.songs = self.songs + song
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                 AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }
        })
    }
    
    @objc func onHandleEditList(){
        if tableView.isEditing {
            DispatchQueue.main.async {
                let backButton = CustomBarButtonItem(title: "\u{f053} Back", style: .plain, target: self, action: #selector(self.onHandleBackTo))
                backButton.setTitleTextAttributes([NSAttributedString.Key.font: AppStateHelper.shared.defaultFontAwesome(size: 17)], for: .normal)
                self.navigationItem.leftBarButtonItem = backButton

                let editButton = CustomBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.onHandleEditList))
                self.navigationItem.rightBarButtonItem = editButton
                self.tableView.setEditing(self.isEditing, animated: true)
            }
        }else{
            DispatchQueue.main.async {
                
                 let deleteButton = CustomBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(self.onHandleDeleteItem))
                self.navigationItem.leftBarButtonItem = deleteButton
                
                let doneButton = CustomBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.onHandleEditList))
                self.navigationItem.rightBarButtonItem = doneButton
                self.tableView.setEditing(!self.isEditing, animated: true)
            }
        }
    }

     @objc func onHandleBackTo(){
        navigationController?.popViewController(animated: true)

    }
    @objc func onHandleDeleteItem(){
        let alertController = UIAlertController(title: "Riffest", message: "Move to trash ? Can't be undo.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            DispatchQueue.main.async {
                self.onHandleEditList()
                AppStateHelper.shared.onHandleShowIndicator()
            }
            let body = ["song_id": self.valuesId]
            TrackerService.onHandleTrackerRemove("mobile/user/history/clear","POST",body,onSuccess: { (success) in
                DispatchQueue.main.async {
                    UserService.onHandleGetSongById(self.url,self.next_page,self.search, { (song) in
                        DispatchQueue.main.async {
                            AppStateHelper.shared.onHandleHideIndicator()
                            self.songs =  song
                            self.valuesId = []
                            self.selectedCells = []
                            self.tableView.separatorStyle = .singleLine
                            self.tableView.reloadData()
                        }
                    }, onError: {(errorString) in
                        DispatchQueue.main.async {
                            AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                        }
                    })
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

extension HistoryController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing == false {
            PlayerController.sharedController.songs = self.songs
            PlayerController.sharedController.indexPlaying = indexPath.row
            (self.tabBarController as? CustomTabBarController)?.songs = self.songs
            (self.tabBarController as? CustomTabBarController)?.indexPlaying = indexPath.row
            (self.tabBarController as? CustomTabBarController)?.setUpShowPlayer()
            (self.tabBarController as? CustomTabBarController)?.handeSetUpPlayer()
        }else{
            selectedCells.append(tableView.cellForRow(at: indexPath)!)
            let deleteButton = CustomBarButtonItem(title: "Delete (\(selectedCells.count))", style: .plain, target: self, action: #selector(self.onHandleDeleteItem))
            self.navigationItem.leftBarButtonItem = deleteButton
            for (index, _) in selectedCells.enumerated() {
                if !valuesId.contains((songs[indexPath.row].id)!) {
                    valuesId.append((songs[indexPath.row].id)!)
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedRow = tableView.cellForRow(at: indexPath)
        if(selectedCells.contains(deselectedRow!)){
            let indx = selectedCells.firstIndex(of: deselectedRow!)
            selectedCells.remove(at: indx!)
            valuesId.remove(at: indx!)
            let deleteButton = CustomBarButtonItem(title: "Delete (\(selectedCells.count))", style: .plain, target: self, action: #selector(self.onHandleDeleteItem))
            self.navigationItem.leftBarButtonItem = deleteButton
        }
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if let aVar = UITableViewCell.EditingStyle(rawValue: 3) {
            return aVar
        }
        return UITableViewCell.EditingStyle(rawValue: 0)!
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 75
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryCell
        cell.song = songs[indexPath.row]
       
        cell.selectionStyle = .default
        cell.tintColor = UIColor.themeBaseColor()
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
}
