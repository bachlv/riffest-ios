import Foundation
import UIKit

class AddPlaylistController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    var url: String = "mobile/user/playlists"
    var myplaylists: [RMMyPlaylist] = []
    var current_index: Int = 0
    var songs: [RMSong] = []
    
    public static var sharedController = AddPlaylistController()
    weak var actionToEnable : UIAlertAction?
    
    private func setupView(){
        tableView?.register(MyPlaylistCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onHandleAddNewPlaylist))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "ADD TO PLAYLIST"
        AddPlaylistController.sharedController = self
        setupView()
        onHandleRequestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func onHandleAddNewPlaylist () {
        let alert = UIAlertController(title: "Create New Playlist", message: "Enter a text", preferredStyle: .alert)
        
        let placeholderStr =  "Create New Playlist"
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = placeholderStr
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) -> Void in
            
        })
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) -> Void in
            let textfield = alert.textFields![0]
            let body = ["title": textfield.text!, "song_id": "\(self.songs[self.current_index].id!)"]
            RMService.onHandlePostPlaylist("mobile/user/playlists","POST",body,onSuccess: { (playlist) in
                DispatchQueue.main.async {
                    if(playlist == true){
                        AppStateHelper.shared.onHandleAlertNotifi(title:"\"\(self.songs[self.current_index].title!)\""+" is added in to the playlist - "+"\"\(textfield.text!)\"")
                        self.onHandleRequestData()
                    }else{
                        AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                    }
                   
                }
            })
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.actionToEnable = action
        action.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textChanged(_ sender:UITextField) {
        if(sender.text!.isEmpty){
            self.actionToEnable?.isEnabled = false
        }else {
            self.actionToEnable?.isEnabled = true
        }
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

extension AddPlaylistController{
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let body = ["playlist_id": "\(myplaylists[indexPath.row].id!)" , "song_id": "\(self.songs[self.current_index].id!)"]
        RMService.onHandlePostPlaylist("mobile/user/playlists/song","POST",body,onSuccess: { (playlist) in
            DispatchQueue.main.async {
                if(playlist == true){
                    AppStateHelper.shared.onHandleAlertNotifi(title:"\"\(self.songs[self.current_index].title!)\""+" is added in to the playlist - "+"\"\(self.myplaylists[indexPath.row].title!)\"")
                    self.onHandleRequestData()
                }else{
                 AppStateHelper.shared.onHandleAlertNotifiError(title:"\"\(self.songs[self.current_index].title!)\""+" is alreadt in to the playlist - "+"\"\(self.myplaylists[indexPath.row].title!)\"")
                }
               
            }
        })
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
        return 100
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
