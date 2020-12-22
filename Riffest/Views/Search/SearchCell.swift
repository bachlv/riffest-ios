import UIKit

class SearchPlaylistCell: UITableViewCell{
    
    var playlist: RMMyPlaylist? {
        didSet {
            if let _playlist = playlist {
                self.textLabel?.text = _playlist.title
                self.detailTextLabel?.text = "By \(_playlist.name!)"
                self.imageView?.sd_setImage(with: URL(string: _playlist.poster!)!, placeholderImage: UIImage(named: "thumbnail"))
                self.TrackLabel.text = "\( _playlist.tracks!) Track(s)"
                if _playlist.status == 0 {
                    self.PrivacyLabel.text = "\u{f023} Private"
                }else{
                    self.PrivacyLabel.text = "\u{f004} \(_playlist.followers!) Followers"
                }
            }
        }
    }
    lazy var TrackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStateHelper.shared.defaultFontRegular(size:10)
        label.textColor = .gray
        return label
    }()
    lazy var PrivacyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStateHelper.shared.defaultFontAwesome(size:12)
        label.textColor = .gray
        return label
    }()
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.textLabel?.font = AppStateHelper.shared.defaultFontBold(size:15)
        self.detailTextLabel?.font = AppStateHelper.shared.defaultFontRegular(size:13)
        self.detailTextLabel?.textColor = UIColor.themeBaseColor()
        self.textLabel?.frame = CGRect(x: 120, y: textLabel!.frame.origin.y - 16, width: 140, height: textLabel!.frame.height)
        self.detailTextLabel?.frame = CGRect(x: 120, y: self.detailTextLabel!.frame.origin.y - 15, width:140, height: self.detailTextLabel!.frame.height)
        self.imageView?.frame = CGRect(x: 15.0,y: 5.0,width: 90.0,height: 90.0)
        self.imageView?.layer.cornerRadius = 5.0
        self.imageView?.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(TrackLabel)
        addSubview(PrivacyLabel)
        
        TrackLabel.leftAnchor.constraint(equalTo: (self.imageView?.leftAnchor)!, constant:106).isActive = true
        TrackLabel.bottomAnchor.constraint(equalTo: (self.detailTextLabel?.bottomAnchor)!, constant: 16).isActive = true
        PrivacyLabel.leftAnchor.constraint(equalTo: (self.imageView?.leftAnchor)!, constant:106).isActive = true
        PrivacyLabel.bottomAnchor.constraint(equalTo: TrackLabel.bottomAnchor, constant: 17).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchArtistCell: UITableViewCell{
    
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


class SearchAlbumCell: UITableViewCell{
    
    var album: RMAlbum? {
        didSet {
            if let _album = album {
                self.textLabel?.text = _album.title
                self.imageView?.sd_setImage(with: URL(string: (_album.poster!))!, placeholderImage: UIImage(named: "thumbnail"))
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

class SearchTrackCell: UITableViewCell {
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
