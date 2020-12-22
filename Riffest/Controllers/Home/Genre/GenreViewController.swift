import Foundation
import UIKit

class GenreViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    static var sharedController = GenreViewController()
    
    var genres: [RMGenre] = []
    var url: String = "mobile/genres"
    var search = ""
    var next_page = 1
    var last_page = 0

    
    fileprivate let cellId = "cellId"
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:15, left: 15, bottom:65, right: 15)
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
        GenreViewController.sharedController = self
        self.view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GenreViewCell.self, forCellWithReuseIdentifier: cellId)
        onHandleGetGenre(next_page: next_page, search: search)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Genres"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling:CGFloat = scrollView.contentOffset.y +   scrollView.frame.size.height
        if(endScrolling >= scrollView.contentSize.height){
            next_page = next_page + 1
            if last_page != 0  {
                DispatchQueue.main.async {
                    self.onHandleGetGenre(next_page: self.next_page, search: self.search)
                }
            }else{
                print("There is no more data.")
            }
        }
    }
    func onHandleGetGenre(next_page: Int, search: String){
        GenreService.onHandleGetAllGenre(url,next_page,search, { (genre) in
            self.last_page = genre.count
            DispatchQueue.main.async {
               self.genres = self.genres + genre
               self.collectionView.reloadData()
            }
        }, onError: {(errorString) in
            DispatchQueue.main.async {
                 AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                }
        })
    }

}

extension GenreViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GenreViewCell
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
        return 20
    }
    
    
}

