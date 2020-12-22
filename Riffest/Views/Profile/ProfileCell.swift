import Foundation
import UIKit


class UserProfileSingleCell: UITableViewCell {
    
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius =  60.0
        imageView.layer.borderWidth = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let NameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStateHelper.shared.defaultFontBold(size:22)
        return label
    }()

    lazy var followButton: UIButton = {
        let button = SAFollowButton(type: .system)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(51, green: 204, blue: 51, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.rgb(51, green: 204, blue: 51, alpha: 1).cgColor
        button.isUserInteractionEnabled = true
        button.setTitle("Follow", for: .normal)
        button.layer.cornerRadius = 5
       // button.addTarget(self, action: #selector(onHandleFollowAndUnFollow), for: .touchUpInside)
        button.titleLabel?.font =  AppStateHelper.shared.defaultFontRegular(size:16)
        return button
    }()
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        addSubview(ImageView)
        addSubview(NameLabel)
        addSubview(followButton)
        ImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        ImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        ImageView.topAnchor.constraint(equalTo: self.topAnchor, constant:10).isActive = true
        
        NameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        NameLabel.rightAnchor.constraint(equalTo: self.ImageView.rightAnchor, constant:140).isActive = true
        
        followButton.bottomAnchor.constraint(equalTo: self.ImageView.bottomAnchor, constant: 90).isActive = true
        followButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true

        followButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class UserProfileCell: UITableViewCell {
    
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius =  60.0
        imageView.layer.borderWidth = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let NameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStateHelper.shared.defaultFontBold(size:18)
        return label
    }()
    let IdLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppStateHelper.shared.defaultFontBold(size:18)
        return label
    }()
    
    override func layoutSubviews(){
        super.layoutSubviews()
        addSubview(ImageView)
        addSubview(NameLabel)
        addSubview(IdLabel)
        ImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        ImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
      
        NameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        NameLabel.bottomAnchor.constraint(equalTo: self.ImageView.bottomAnchor, constant: 30).isActive = true
        
        IdLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        IdLabel.bottomAnchor.constraint(equalTo: self.NameLabel.bottomAnchor, constant: 25).isActive = true

    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ProfileUserCell: UITableViewCell {
    
    override func layoutSubviews(){
        super.layoutSubviews()
        textLabel?.font = AppStateHelper.shared.defaultFontRegular(size: 18)
        textLabel?.frame = CGRect(x:90,y: 30, width: 300, height: 30)
        self.imageView?.frame = CGRect(x:20,y:15,width: 60.0,height: 60.0)
        self.imageView?.layer.cornerRadius = ((self.imageView?.bounds.width)!/2)
        self.imageView?.clipsToBounds = true
        self.imageView?.tintColor = UIColor.themeBaseColor()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfileSubscriptionCell: UITableViewCell {
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font =  AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font =  AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(ImageView)
        addSubview(titleLabel)
        addSubview(subLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 45).isActive = true
        
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        if UIDevice().userInterfaceIdiom == .pad {
            subLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -65).isActive = true
        }else {
            subLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -35).isActive = true
        }
        subLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ProfilePersnalCell: UITableViewCell {
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font =  AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font =  AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(ImageView)
        addSubview(titleLabel)
        addSubview(subLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 45).isActive = true
        
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        subLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ProfileCell: UITableViewCell {
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font =  AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font =  AppStateHelper.shared.defaultFontRegular(size: 16)
        return label
    }()
    let ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2.0
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(ImageView)
        addSubview(titleLabel)
        addSubview(subLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: ImageView.leftAnchor, constant: 45).isActive = true
        
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        ImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        ImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        ImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        subLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        subLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
