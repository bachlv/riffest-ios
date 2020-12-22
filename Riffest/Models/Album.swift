import Foundation
import UIKit
import Realm
import RealmSwift

class AlbumDownloaded: Object{
    
    @objc dynamic var albumID = UUID().uuidString
    override static func primaryKey() -> String? {
        return "albumID"
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var followers: Int = 0
    
}


class RMAlbum: NSObject {
    
    var id: Int?
    var title: String?
    var poster: String?
    var followers: Int? = 0
    
    override init() {
        super.init()
    }
    init(withDictionary dic: NSDictionary) {
        self.id = dic.value(forKey: "id") as? Int
        self.title = dic.value(forKey: "title") as? String ?? ""
        self.poster = dic.value(forKey: "poster") as? String ?? ""
        self.followers = dic.value(forKey: "followers") as? Int ?? 0
    }
}
