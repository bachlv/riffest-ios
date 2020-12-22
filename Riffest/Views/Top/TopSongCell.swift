import UIKit

class TopThisWeekCell: UITableViewCell {
    
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
        self.detailTextLabel?.frame = CGRect(x: 85, y: detailTextLabel!.frame.origin.y, width:90, height: detailTextLabel!.frame.height)
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


class TopSonCell: UICollectionViewCell{
    
    var indexPath: Int = 0
    
    var song: RMSong? {
        didSet {
            if let _song = song {
                TitleLabel.text = _song.title
                NameLabel.text = _song.artist_name
                ImageView.sd_setImage(with: URL(string: _song.poster!)!, placeholderImage: UIImage(named: "thumbnail"))
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
        label.textAlignment = .left
        label.font = AppStateHelper.shared.defaultFontRegular(size:14)
        return label
    }()
    
    let NameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = AppStateHelper.shared.defaultFontRegular(size:12)
        return label
    }()
    let viewOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(21, green: 22, blue: 24, alpha: 0.6)
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        if #available(iOS 11.0, *) {
            view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            view.roundCorners([.bottomLeft, .bottomRight], radius: 5.0)

        }
        return view
    }()

    lazy var addPlaylistButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("\u{f067}", for: .normal)
        button.titleLabel?.font = AppStateHelper.shared.defaultFontAwesome(size:15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControl.State())
        button.addTarget(self, action: #selector(onHandleAddPlaylist), for: .touchUpInside)

        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("\u{f141}", for: .normal)
        button.titleLabel?.font = AppStateHelper.shared.defaultFontAwesome(size:15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onHandleMoreOption), for: .touchUpInside)

        button.setTitleColor(.white, for: UIControl.State())
        return button
    }()
    @objc func onHandleMoreOption () {
        AppStateHelper.shared.onHandleSongMore(song: song!, button: moreButton)
    }
    @objc func onHandleAddPlaylist () {
        TopController.sharedController.OnHandleAddPlaylist(indexPath: indexPath)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(ImageView)
        addSubview(TitleLabel)
        addSubview(NameLabel)
        addSubview(viewOverlay)
        viewOverlay.addSubview(addPlaylistButton)
        viewOverlay.addSubview(moreButton)
        
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.bottomAnchor.constraint(equalTo: self.ImageView.bottomAnchor,constant: 30).isActive = true
        TitleLabel.widthAnchor.constraint(equalToConstant: 120).isActive =  true
        TitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        NameLabel.translatesAutoresizingMaskIntoConstraints = false
        NameLabel.bottomAnchor.constraint(equalTo: self.TitleLabel.bottomAnchor,constant: 18).isActive = true
        NameLabel.widthAnchor.constraint(equalToConstant: 100).isActive =  true
        NameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        ImageView.image = UIImage(named: "thumbnail")
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ImageView.widthAnchor.constraint(equalToConstant: 120).isActive =  true
        ImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        addPlaylistButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        addPlaylistButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addPlaylistButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addPlaylistButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -34).isActive = true
        
        moreButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        moreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -34).isActive = true

        viewOverlay.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        viewOverlay.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        viewOverlay.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
        viewOverlay.widthAnchor.constraint(equalToConstant: 120).isActive = true
        viewOverlay.heightAnchor.constraint(equalToConstant: 30).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
