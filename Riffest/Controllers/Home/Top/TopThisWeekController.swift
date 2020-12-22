import Foundation
import UIKit

class TopThisWeekController: UITableViewController {
    
    var songs: [RMSong] = []
    
    fileprivate let cellId = "cellId"
    public static var sharedController = TopThisWeekController()
    var url: String = "mobile/top-this-week"
    var search = ""
    var next_page = 1
    var last_page = 0
    
    private func setupView(){
        tableView?.register(TopThisWeekCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TopThisWeekController.sharedController = self
        setupView()
        onHandleGetSong(next_page: next_page, search: search)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        TopService.onHandleGetSongById(url,next_page,search, { (song) in
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
    
    
}

extension TopThisWeekController {
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerController.sharedController.songs = self.songs
        PlayerController.sharedController.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.songs = self.songs
        (self.tabBarController as? CustomTabBarController)?.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.setUpShowPlayer()
        (self.tabBarController as? CustomTabBarController)?.handeSetUpPlayer()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TopThisWeekCell
        cell.song = songs[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
}

