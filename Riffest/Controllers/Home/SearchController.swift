import Foundation
import UIKit

class SearchController: UITableViewController {
    
    lazy var searchBar:UISearchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    fileprivate let cellId = "cellId"
    fileprivate let cellArtistId = "cellArtistId"
    fileprivate let cellPlaylistId = "cellPlaylistId"
    fileprivate let cellAlbumtId = "cellAlbumtId"

    var songs: [RMSong] = []
    var artists: [RMArtists] = []
    var albums: [RMAlbum] = []
    var playlists: [RMMyPlaylist] = []
    var search = ""
    var searchTemp = ""

    var headerTitle = ["Artists","Tracks","Playlists","Albums"]
    
    private func setupView(){
        
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        tableView.register(SearchTrackCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SearchArtistCell.self, forCellReuseIdentifier: cellArtistId)
        tableView.register(SearchPlaylistCell.self, forCellReuseIdentifier: cellPlaylistId)
        tableView.register(SearchAlbumCell.self, forCellReuseIdentifier: cellAlbumtId)

        tableView.separatorStyle = .none
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
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Search"
        self.view.backgroundColor = .white
        setupView()

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
        searchTemp =  searchBar.text!
        
        if !(searchText.isEmpty) {
            debouncer.call()
            debouncer.callback = {
                self.search = searchBar.text!
                self.onHandleRequest(search: self.search)
            }
        } else {
            DispatchQueue.main.async {
                 self.songs = []
                 self.artists = []
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
        onHandleRequest(search: search)
    }
    func onHandleRequest(search: String){
        if search.isEmpty {
            return
        }
        AppStateHelper.shared.onHandleShowIndicator()
        SearchService.onHandleGetSearch("mobile/search?query="+search,{ (song,artist,playlist,album) in
            DispatchQueue.main.async {
                AppStateHelper.shared.onHandleHideIndicator()

                self.songs = song
                self.artists = artist
                self.playlists = playlist
                self.albums = album
                self.tableView?.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                 AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }
            print("error")
        })
    }
    
    @objc func onHandleSeeMore(sender: UIButton!) {
        if sender.tag == 0 {
            let searchArtistController = SearchArtistController()
            searchArtistController.search = searchTemp
            navigationController?.pushViewController(searchArtistController, animated: true)
        } else if sender.tag == 1 {
            let searchTrackController = SearchTrackController()
            searchTrackController.search = searchTemp
            navigationController?.pushViewController(searchTrackController, animated: true)
        } else if sender.tag ==  2 {
            let searchPlaylistController = SearchPlaylistController()
            searchPlaylistController.search = searchTemp
            navigationController?.pushViewController(searchPlaylistController, animated: true)
        } else if sender.tag == 3 {
            let searchAlbumController = SearchAlbumController()
            searchAlbumController.search = searchTemp
            navigationController?.pushViewController(searchAlbumController, animated: true)
        }
    }
    
}
extension SearchController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension SearchController{
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            let artistSingleController = ArtistSingleController()
            artistSingleController.artists = self.artists
            artistSingleController.currentIndex = indexPath.row
            navigationController?.pushViewController(artistSingleController, animated: true)
            
        }else if indexPath.section == 1 {
            
            PlayerController.sharedController.songs = self.songs
            PlayerController.sharedController.indexPlaying = indexPath.row
            (self.tabBarController as? CustomTabBarController)?.songs = self.songs
            (self.tabBarController as? CustomTabBarController)?.indexPlaying = indexPath.row
            (self.tabBarController as? CustomTabBarController)?.setUpShowPlayer()
            (self.tabBarController as? CustomTabBarController)?.handeSetUpPlayer()
            
        }else if indexPath.section == 2{
            let playlistSingleController = FeaturedPlaylistSingleController()
            playlistSingleController.playlists = playlists
            playlistSingleController.currentIndex = indexPath.row
            navigationController?.pushViewController(playlistSingleController, animated: true)
        }else  {
            
            let albumFollowerController = AlbumFollowerController()
            albumFollowerController.albums = albums
            albumFollowerController.currentIndex = indexPath.row
            navigationController?.pushViewController(albumFollowerController, animated: true)
            
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return 75
        } else if indexPath.section == 1 {
            return 75
        }else if indexPath.section == 2{
            return 100
        }else{
             return 75
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch section {
        case 0:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                 return 42
            }
        case 1:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                 return 42
            }
        case 2:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                 return 42
            }
        case 3:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return 42
            }
        default:
            return 0
        }
        return 0
    }
   
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let subView = UIView()
        let label = UILabel()
        subView.backgroundColor = UIColor.themeHeaderColor()
        label.text = headerTitle[section]
        label.font = AppStateHelper.shared.defaultFontRegular(size:18)

        subView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.leftAnchor.constraint(equalTo: subView.leftAnchor,constant: 15).isActive = true
        let button = UIButton()
        button.setTitleColor(UIColor.themeBaseColor(), for: UIControl.State())
        button.titleLabel?.font = AppStateHelper.shared.defaultFontRegular(size:15)
        button.setTitle("See All >", for: .normal)
        button.alpha = 1.0
        button.tag = section
        button.addTarget(self, action: #selector(onHandleSeeMore), for: .touchUpInside)
        subView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.rightAnchor.constraint(equalTo: subView.rightAnchor, constant: -10 ).isActive = true
        return subView
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
            return headerTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return artists.count
        }else if section == 1{
            return songs.count
        }else if section == 2 {
            return playlists.count
        }else {
            return albums.count
        }
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:cellArtistId, for: indexPath) as! SearchArtistCell
            cell.artist = artists[indexPath.row]
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.backgroundColor = .white
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for: indexPath) as! SearchTrackCell
            cell.song = songs[indexPath.row]
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.backgroundColor = .white
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier:cellPlaylistId, for: indexPath) as! SearchPlaylistCell
            cell.playlist = playlists[indexPath.row]
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.backgroundColor = .white
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier:cellAlbumtId, for: indexPath) as! SearchAlbumCell
            cell.album = albums[indexPath.row]
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.backgroundColor = .white
            return cell
        }
        
     }
 
}
