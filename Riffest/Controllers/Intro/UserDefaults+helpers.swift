import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case isOffline
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    // offline mode
    func setIsOffline(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isOffline.rawValue)
        synchronize()
    }
    
    func isOffline() -> Bool {
        return bool(forKey: UserDefaultsKeys.isOffline.rawValue)
    }
    
}
