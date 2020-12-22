import Foundation
import UIKit

class NewReleaseController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    public static var sharedController = NewReleaseController()
    
    fileprivate let cellId = "cellId"
    var songs: [RMSong] = []
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top:5, left: 15, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 120, height: 160)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.collectionViewLayout.invalidateLayout()
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewReleaseController.sharedController = self
        self.view.addSubview(collectionView)
        collectionView.register(ReleaseCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.width, height: 180)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onHandleReload(song: [RMSong]){
        DispatchQueue.main.async {
            self.songs = song
            self.collectionView.reloadData()
        }
    }
    func OnHandleAddPlaylist(indexPath:Int){
        let addPlaylistController = AddPlaylistController()
        addPlaylistController.current_index = indexPath
        addPlaylistController.songs = self.songs
        navigationController?.pushViewController(addPlaylistController, animated: true)
    }
    
}

extension NewReleaseController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PlayerController.sharedController.songs = self.songs
        PlayerController.sharedController.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.songs = self.songs
        (self.tabBarController as? CustomTabBarController)?.indexPlaying = indexPath.row
        (self.tabBarController as? CustomTabBarController)?.setUpShowPlayer()
        (self.tabBarController as? CustomTabBarController)?.handeSetUpPlayer()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReleaseCell
        cell.indexPath = indexPath.row
        cell.song = songs[indexPath.row]
        return cell
    }
}
