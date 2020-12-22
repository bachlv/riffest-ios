import Foundation

import UIKit

extension UIColor {
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    static func themeBaseColor() -> UIColor {
        return rgb(255, green: 44, blue: 85, alpha: 1.0)
    }
    static func themeHeaderColor() -> UIColor {
        return rgb(239, green: 239, blue: 244, alpha: 1.0)
    }
    
    static func themeLeftColor() -> UIColor {
        return  UIColor.rgb(86, green: 197, blue: 238, alpha: 0.3)
    }
    static func themeRightColor() -> UIColor {
        return rgb(112, green: 219, blue: 155, alpha: 0.3)
    }
    
    static func themeBaseBgColor() -> UIColor {
        return rgb(255, green: 44, blue: 85, alpha: 0.8)
    }
    

}
