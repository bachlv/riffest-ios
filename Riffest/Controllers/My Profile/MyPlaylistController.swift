import Foundation
import UIKit

class MyPlaylistController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    var url: String = "mobile/user/playlists"
    var myplaylists: [RMMyPlaylist] = []

    public static var sharedController = MyPlaylistController()
    
    private func setupView(){
        tableView?.register(MyPlaylistCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: AppStateHelper.shared.defaultFontBold(size: 32), NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationItem.hidesSearchBarWhenScrolling = false
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MyPlaylistController.sharedController = self
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "My Playlists"
        onHandleRequestData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onHandleRequestData(){
        RMService.onHandleGetMyPlaylist(url,{ (myplaylist) in
            DispatchQueue.main.async {
                self.myplaylists = myplaylist
                self.tableView?.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                 AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }
        })
    }
}

extension MyPlaylistController{
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistSingleController = PlaylistSingleController()
        playlistSingleController.playlists = myplaylists
        playlistSingleController.isEditPlaylist = true
        playlistSingleController.currentIndex = indexPath.row
        navigationController?.pushViewController(playlistSingleController, animated: true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myplaylists.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 101
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyPlaylistCell
      cell.playlist = myplaylists[indexPath.row]
      cell.separatorInset =  .zero
      cell.layoutMargins = .zero
      cell.selectionStyle = .none
      return cell
    }
 
}
