import Foundation
import Foundation
import UIKit

class FeaturedPlaylistController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    static var sharedController = FeaturedPlaylistController()
    
    var playlists: [RMMyPlaylist] = []
    
    fileprivate let cellId = "cellId"
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top:5, left: 15, bottom:0, right: 10)
        layout.itemSize = CGSize(width: 120, height: 160)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.collectionViewLayout.invalidateLayout()
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FeaturedPlaylistController.sharedController = self
        self.view.addSubview(collectionView)
        collectionView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.width, height: 180)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeaturedCell
        cell.playlist = playlists[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlistSingleController = FeaturedPlaylistSingleController()
        playlistSingleController.playlists = playlists
        playlistSingleController.currentIndex = indexPath.row
        navigationController?.pushViewController(playlistSingleController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func onHandleReload(playlist: [RMMyPlaylist]){
        DispatchQueue.main.async {
            self.playlists = playlist
            self.collectionView.reloadData()
        }
    }
    
}



