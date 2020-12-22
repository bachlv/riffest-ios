import UIKit
import Realm
import RealmSwift

class ArtistDownloaded: Object{
    
    @objc dynamic var artistID = UUID().uuidString
    override static func primaryKey() -> String? {
        return "artistID"
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var followers: Int = 0
    
}


class RMArtists: NSObject {
    
    var id: Int?
    var name: String?
    var poster: String?
    var followers: Int? = 0
    override init() {
        super.init()
    }
    init(withDictionary dic: NSDictionary) {
        self.id = dic.value(forKey: "id") as? Int 
        self.name = dic.value(forKey: "name") as? String ?? ""
        self.poster = dic.value(forKey: "poster") as? String ?? ""
        self.followers = dic.value(forKey: "followers") as? Int ?? 0
    }
}
