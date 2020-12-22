import Foundation
import UIKit

struct Colors {
    static let twitterBlue = UIColor.themeBaseColor()
}

class SAFollowButton: UIButton {
    
    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.twitterBlue.cgColor
        layer.cornerRadius = frame.size.height/2
        titleLabel?.font = AppStateHelper.shared.defaultFontAwesome(size:15)

        setTitleColor(Colors.twitterBlue, for: .normal)
        addTarget(self, action: #selector(SAFollowButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        let title = bool ? "\u{f004} Following" : "\u{f004} Follow"
        let titleColor = bool ? UIColor.white : UIColor.white
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = UIColor.themeBaseColor()

    }
    
    
}

class ShuffleButton: UIButton {
    
    var isOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.twitterBlue.cgColor
        layer.cornerRadius = frame.size.height/2
        setTitleColor(Colors.twitterBlue, for: .normal)
        addTarget(self, action: #selector(SAFollowButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    
    func activateButton(bool: Bool) {
        isOn = bool
        let title = bool ? "Unshuffle" : "Shuffle"
        let titleColor = bool ? UIColor.white : UIColor.white
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = UIColor.themeBaseColor()
        
    }
    
    
}
