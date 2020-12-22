import Foundation

import UIKit

class RMGenre: NSObject {
    var id: Int?
    var name: String?
    var poster: String?
    
    override init() {
        super.init()
    }
    init(withDictionary dic: NSDictionary) {
        self.id = dic.value(forKey: "id") as? Int
        self.name = dic.value(forKey: "name") as? String ?? ""
        self.poster = dic.value(forKey: "poster") as? String ?? ""
    }
}
