import Foundation
import UIKit

class TopArtistController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    public static var sharedController = TopArtistController()
    var artists: [RMArtists] = []
    var url: String = "mobile/top-artists"
    var search = ""
    var next_page = 1
    var last_page = 0
    
    
    private func setupView(){
        tableView?.register(TopArtistCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        TopArtistController.sharedController = self
        setupView()
        onHandleGetData(next_page: next_page, search: search)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Top Artists"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
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
                    self.onHandleGetData(next_page: self.next_page, search: self.search)
                }
            }
        }
    }
    func onHandleGetData(next_page: Int, search: String){
        // we used the same files TopService we dont want to create more because it is the same
        RMArtistService.onHandleGetTopArtist(url,next_page,search, { (artist) in
            self.last_page = artist.count
            DispatchQueue.main.async {
                self.artists = self.artists + artist
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

extension TopArtistController{
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artistSingleController = ArtistSingleController()
        artistSingleController.artists = artists
        artistSingleController.currentIndex = indexPath.row
        navigationController?.pushViewController(artistSingleController, animated: true)
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
        return artists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TopArtistCell
        cell.artist = artists[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
    
}
