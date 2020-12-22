import UIKit

class MyPlaylistCell: UITableViewCell {
    
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
        self.textLabel?.frame = CGRect(x: 120, y: textLabel!.frame.origin.y - 16, width: UIScreen.main.bounds.width - 160, height: textLabel!.frame.height)
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
