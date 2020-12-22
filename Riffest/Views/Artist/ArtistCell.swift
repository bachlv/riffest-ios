import UIKit

class TopArtistCell: UITableViewCell{
    
    var artist: RMArtists? {
        didSet {
            if let _artist = artist {
                self.textLabel?.text = _artist.name
                self.imageView?.sd_setImage(with: URL(string: (_artist.poster!))!, placeholderImage: UIImage(named: "thumbnail"))
            }
        }
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 85,y:20, width: 300, height: 30)
        textLabel?.font = AppStateHelper.shared.defaultFontRegular(size: 15)
        self.imageView?.frame = CGRect(x:15.0,y: 7.0,width: 60.0,height: 60.0)
        self.imageView?.layer.cornerRadius = 5.0
        self.imageView?.clipsToBounds = true
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ArtistTrackCell: UITableViewCell {
    
    var song: RMSong? {
        didSet {
            if let _song = song {
                self.textLabel?.text = _song.title
                self.detailTextLabel?.text = _song.artist_name
                self.imageView?.sd_setImage(with: URL(string: _song.poster!)!, placeholderImage: UIImage(named: "thumbnail"))
                duringButton.setTitle(_song.duration, for: .normal)
            }
        }
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.textLabel?.frame = CGRect(x: 85, y: textLabel!.frame.origin.y - 4, width: UIScreen.main.bounds.width - 165, height: textLabel!.frame.height)
        self.detailTextLabel?.frame = CGRect(x: 85, y: detailTextLabel!.frame.origin.y, width:220, height: detailTextLabel!.frame.height)
        self.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size:16)
        self.detailTextLabel?.font = AppStateHelper.shared.defaultFontRegular(size:14)
        
        self.imageView?.frame = CGRect(x: 15.0,y: 7.0,width: 60.0,height: 60.0)
        self.imageView?.layer.cornerRadius = 5.0
        self.imageView?.clipsToBounds = true
        self.textLabel?.textColor = .black
        self.detailTextLabel?.textColor = .gray

    }
    lazy var duringButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("00:00", for: .normal)
        button.titleLabel?.font = AppStateHelper.shared.defaultFontRegular(size:16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.themeBaseColor(), for: UIControl.State())
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("\u{f142}", for: .normal)
        button.titleLabel?.font = AppStateHelper.shared.defaultFontAwesome(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.themeBaseColor(), for: UIControl.State())
        button.addTarget(self, action: #selector(handleMoreIfo), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMoreIfo () {
        AppStateHelper.shared.onHandleSongMore(song: song!, button: moreButton)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(duringButton)
        addSubview(moreButton)
        
        duringButton.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -40).isActive = true
        duringButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        duringButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        duringButton.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        moreButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class PopluarCell: UICollectionViewCell{
    
    var artist: RMArtists? {
        didSet {
            if let _artist = artist {
                TitleLabel.text = _artist.name
                ImageView.sd_setImage(with: URL(string: (_artist.poster!))!, placeholderImage: UIImage(named: "thumbnail"))
            }
        }
    }
    
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let TitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = AppStateHelper.shared.defaultFontBold(size:15)
        return label
    }()
    
    var cover = UIView()
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(ImageView)
        addSubview(cover)
        addSubview(TitleLabel)
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.bottomAnchor.constraint(equalTo: self.ImageView.bottomAnchor,constant: 40).isActive = true
        TitleLabel.widthAnchor.constraint(equalToConstant: 140).isActive =  true

        TitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ImageView.image = UIImage(named: "thumbnail")
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ImageView.widthAnchor.constraint(equalToConstant: 120).isActive =  true
        ImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        cover.widthAnchor.constraint(equalToConstant: 120).isActive =  true
        cover.heightAnchor.constraint(equalToConstant: 120).isActive = true
        gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(x:0,y:0,width: 120,height:120)
        gradientLayer.colors = [UIColor.themeLeftColor().cgColor, UIColor.themeLeftColor().cgColor]
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
        gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        cover.layer.cornerRadius = 60.0
        cover.layer.masksToBounds = true
        cover.layer.addSublayer(gradientLayer)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
