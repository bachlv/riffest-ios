import Foundation
import UIKit
class FeaturedCell: UICollectionViewCell{
    
    var playlist: RMMyPlaylist? {
        didSet {
            if let _playlist = playlist {
                TitleLabel.text = _playlist.title
                ImageView.sd_setImage(with: URL(string: (_playlist.poster!))!, placeholderImage: UIImage(named: "thumbnail"))
            }
        }
    }
    
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let TitleLabel: UILabel = {
        let label = UILabel()
        //label.lineBreakMode = .byWordWrapping
       // label.numberOfLines = 0
        label.textAlignment = .center
        label.font = AppStateHelper.shared.defaultFontRegular(size:15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(ImageView)
        addSubview(TitleLabel)
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.bottomAnchor.constraint(equalTo: self.ImageView.bottomAnchor,constant: 32).isActive = true
        TitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TitleLabel.widthAnchor.constraint(equalToConstant: 120).isActive =  true

        ImageView.image = UIImage(named: "thumbnail")
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ImageView.widthAnchor.constraint(equalToConstant: 120).isActive =  true
        ImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
