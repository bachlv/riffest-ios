import Foundation
import UIKit

class SearchPlaylistController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    public static var sharedController = SearchPlaylistController()
    var playlists: [RMMyPlaylist] = []
    var url: String = "mobile/search/playlist"
    var search = ""
    var next_page = 1
    var last_page = 0
    
    lazy var searchBar:UISearchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    
    private func setupView(){
        tableView?.register(SearchPlaylistCell.self, forCellReuseIdentifier: cellId)
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: AppStateHelper.shared.defaultFontBold(size: 32), NSAttributedString.Key.foregroundColor: UIColor.black]
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            navigationController?.navigationBar.prefersLargeTitles = true
        }else {
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = true
            searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
            self.tableView.tableHeaderView = searchController.searchBar
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Playlists"
        SearchPlaylistController.sharedController = self
        setupView()
        onHandleGetData(next_page: next_page, search: search)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let debouncer = Debouncer(interval: 0.5)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if !(searchText.isEmpty) {
            debouncer.call()
            debouncer.callback = {
                self.search = searchBar.text!
                self.onHandleGetData(next_page: self.next_page, search: self.search)
            }
        } else {
            DispatchQueue.main.async {
                self.playlists = []
                self.tableView.separatorStyle = .none
                self.tableView.reloadData()
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            return
        }
        search = searchBar.text!
        onHandleGetData(next_page: next_page, search: search)
    }
    func onHandleGetData(next_page: Int, search: String){
        // we used the same files TopService we dont want to create more because it is the same
        PlaylistService.onHandleGetBestPlaylist(url,next_page,search, { (playlist) in
            DispatchQueue.main.async {
                self.playlists =  playlist
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
extension SearchPlaylistController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}
extension SearchPlaylistController{
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlistSingleController = FeaturedPlaylistSingleController()
        playlistSingleController.playlists = playlists
        playlistSingleController.currentIndex = indexPath.row
        navigationController?.pushViewController(playlistSingleController, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 101
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchPlaylistCell
        cell.playlist = playlists[indexPath.row]
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.backgroundColor = .white
        return cell
    }
    
}
