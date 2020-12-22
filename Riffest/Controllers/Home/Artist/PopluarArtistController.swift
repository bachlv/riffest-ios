import Foundation
import UIKit

class PopularArtistController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    static var sharedController = PopularArtistController()
    
    var artists: [RMArtists] = []
    
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
        // Do any additional setup after loading the view, typically from a nib.
        // self.view.backgroundColor = UIColor.themebgNav()
        PopularArtistController.sharedController = self
        self.view.addSubview(collectionView)
        collectionView.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.width, height: 180)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PopluarCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PopluarCell
        cell.artist = artists[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artistSingleController = ArtistSingleController()
        artistSingleController.artists = artists
        artistSingleController.currentIndex = indexPath.row
        navigationController?.pushViewController(artistSingleController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func onHandleReload(artist: [RMArtists]){
        DispatchQueue.main.async {
            self.artists = artist
            self.collectionView.reloadData()
        }
    }
    
}



