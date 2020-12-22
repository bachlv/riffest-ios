import UIKit
import SDWebImage

class PlayerMusicCell: UITableViewCell {
    
    var delegate: PlayerMusicCellCellDelegate?
    var indexPath: Int = 0
    
    let musicIndicator = ESTMusicIndicatorView()
    var state: ESTMusicIndicatorViewState = .stopped {
        didSet {
            musicIndicator.state = state
        }
    }
    
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
        detailTextLabel?.textColor = .gray
        self.textLabel?.frame = CGRect(x: 85, y: textLabel!.frame.origin.y - 4, width: UIScreen.main.bounds.width - 165, height: textLabel!.frame.height)
        self.detailTextLabel?.frame = CGRect(x: 85, y: detailTextLabel!.frame.origin.y, width:90, height: detailTextLabel!.frame.height)
        
        self.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size:16)
        self.detailTextLabel?.font = AppStateHelper.shared.defaultFontRegular(size:14)
        self.imageView?.frame = CGRect(x: 15.0,y: 7.0,width: 60.0,height: 60.0)
        self.imageView?.layer.cornerRadius = 5.0
        self.imageView?.clipsToBounds = true
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
        button.tag = 1
        return button
    }()
    
    @objc func handleMoreIfo () {
        AppStateHelper.shared.onHandleSongMore(song: song!, button: moreButton)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(duringButton)
        addSubview(musicIndicator)
        addSubview(moreButton)
        
        duringButton.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -30).isActive = true
        duringButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        duringButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        duringButton.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        moreButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        moreButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        musicIndicator.tintColor = .white
        musicIndicator.translatesAutoresizingMaskIntoConstraints = false
        musicIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        musicIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        musicIndicator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 34).isActive = true
        musicIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MusicCell: UITableViewCell {
    
    var song: RMSong? {
        didSet {
            if let _song = song {
                TitleLabel.text = _song.title
                NameLabel.text = _song.artist_name
                ImageView.sd_setImage(with: URL(string: _song.poster!)!, placeholderImage: UIImage(named: "thumbnail"))
                TimeLabel.text = _song.duration
            }
        }
    }
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "thumbnail")
        imageView.layer.cornerRadius = 30.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let TitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.themeBaseColor()
        label.font = AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    
    let NameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = AppStateHelper.shared.defaultFontRegular(size:14)
        return label
    }()
    
    let TimeLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "00:00"
        label.textAlignment = .right
        label.textColor = UIColor.themeBaseColor()
        label.font = AppStateHelper.shared.defaultFontRegular(size:13)
        return label
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("\u{f142}", for: .normal)
        button.titleLabel?.font = AppStateHelper.shared.defaultFontAwesome(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .focused)
        button.tintColor = UIColor.themeBaseColor()
        button.addTarget(self, action: #selector(onHandleMore), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        addSubview(ImageView)
        addSubview(TitleLabel)
        addSubview(NameLabel)
        addSubview(TimeLabel)
        addSubview(moreButton)
        
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.leftAnchor.constraint(equalTo: self.ImageView.leftAnchor,constant:75).isActive = true
        TitleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100).isActive =  true
        TitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        TitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        NameLabel.translatesAutoresizingMaskIntoConstraints = false
        NameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        NameLabel.leftAnchor.constraint(equalTo: self.ImageView.leftAnchor,constant: 75).isActive = true
        NameLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        TimeLabel.translatesAutoresizingMaskIntoConstraints = false
        TimeLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -30).isActive = true
        TimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        TimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        TimeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        moreButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        moreButton.rightAnchor.constraint(equalTo: TimeLabel.rightAnchor,constant: 30).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.widthAnchor.constraint(equalToConstant: 60).isActive =  true
        ImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        ImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        ImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc  func onHandleMore() {
        AppStateHelper.shared.onHandleSongMore(song: song!, button: moreButton)
    }
}
