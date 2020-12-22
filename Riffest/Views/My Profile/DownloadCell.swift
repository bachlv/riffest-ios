import Foundation
import UIKit
import DownloadButton
import RealmSwift

class DownloadCell: UITableViewCell {
    
    override func layoutSubviews(){
        super.layoutSubviews()
        detailTextLabel?.textColor = .gray
        
        textLabel?.frame = CGRect(x: 85, y: textLabel!.frame.origin.y, width: 200, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 85, y: detailTextLabel!.frame.origin.y, width: 200, height: detailTextLabel!.frame.height)
        
        self.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size:16)
        self.detailTextLabel?.font = AppStateHelper.shared.defaultFontRegular(size:14)
        self.imageView?.frame = CGRect(x: 15.0,y: 5.0,width: 55.0,height: 55.0)
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(duringButton)
        duringButton.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10).isActive = true
        duringButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        duringButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        duringButton.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DownloadingCell: UITableViewCell {
    
    var delegate: DownloadingCellDelegate?
    var indexPathRow: Int = 0
    
    let sizeDownloading: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .right
        label.font =  AppStateHelper.shared.defaultFontRegular(size: 9)
        return label
    }()
    
    override func layoutSubviews(){
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 85, y: textLabel!.frame.origin.y, width: 200, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 85, y: detailTextLabel!.frame.origin.y, width: 90, height: detailTextLabel!.frame.height)
        
        detailTextLabel?.textColor = .gray
        self.textLabel?.font = AppStateHelper.shared.defaultFontRegular(size:16)
        self.detailTextLabel?.font = AppStateHelper.shared.defaultFontRegular(size:14)
        self.imageView?.frame = CGRect(x: 15.0,y: 5.0,width: 55.0,height: 55.0)
        self.imageView?.layer.cornerRadius = 5.0
        self.imageView?.clipsToBounds = true
    }
    
    var downloadButton = PKDownloadButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(downloadButton)
        addSubview(sizeDownloading)
        sizeDownloading.translatesAutoresizingMaskIntoConstraints = false
        sizeDownloading.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -55).isActive = true
        sizeDownloading.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8).isActive = true
        sizeDownloading.text = "Calculating..."
        sizeDownloading.heightAnchor.constraint(equalToConstant: 35).isActive = true
        sizeDownloading.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.stopDownloadButton.tintColor = UIColor.themeBaseColor()
        let attributedString =
            NSAttributedString(string: " \u{f0ed} ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.themeBaseColor(), NSAttributedString.Key.font: AppStateHelper.shared.defaultFontAwesome(size: 16)])
        downloadButton.startDownloadButton!.setAttributedTitle(attributedString, for: .normal)
        downloadButton.startDownloadButton.tintColor = UIColor.themeBaseColor()
        downloadButton.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10).isActive = true
        downloadButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        downloadButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        downloadButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        downloadButton.state = .startDownload
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellForRowAtIndexPath(_ indexPath : IndexPath, downloadModel: MZDownloadModel) {
        self.downloadButton.stopDownloadButton.progress = CGFloat(downloadModel.progress)
        
        var speed = ""
        if let _ = downloadModel.speed?.speed {
            speed = String(format: "%.2f %@/sec", (downloadModel.speed?.speed)!, (downloadModel.speed?.unit)!)
        }
        
        var fileSize = ""
        if let _ = downloadModel.file?.size {
            fileSize = String(format: "%.2f %@", (downloadModel.file?.size)!, (downloadModel.file?.unit)!)
        }
        
        var downloadedFileSize = "Calculating..."
        if let _ = downloadModel.downloadedFile?.size {
            downloadedFileSize = String(format: "%.2f %@", (downloadModel.downloadedFile?.size)!, (downloadModel.downloadedFile?.unit)!)
        }
        let detailLabelText = NSMutableString()
        detailLabelText.appendFormat("\(downloadedFileSize)/\(fileSize)\nSpeed: \(speed)" as NSString)
        self.sizeDownloading.text = detailLabelText as String
    }
    
}



