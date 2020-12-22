import Foundation
import UIKit

class GenreController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    static var sharedController = GenreController()
    
    var genres: [RMGenre] = []
    
    fileprivate let cellId = "cellId"
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets(top:0, left: 15, bottom:0, right: 10)
        layout.itemSize = CGSize(width: 240, height: 130)
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
        GenreController.sharedController = self
        self.view.addSubview(collectionView)
        collectionView.frame = CGRect(x:0,y:-5, width: UIScreen.main.bounds.width, height: 180)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BrowserGenreCell.self, forCellWithReuseIdentifier: cellId)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func onHandleReload(genre: [RMGenre]){
        DispatchQueue.main.async {
            self.genres = genre
            self.collectionView.reloadData()
        }
    }
    
}

extension GenreController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BrowserGenreCell
        cell.genre = genres[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genreDetailController = GenreDetailController()
        genreDetailController.genreId = genres[indexPath.row].id!
        genreDetailController.title = genres[indexPath.row].name
        navigationController?.pushViewController(genreDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}


