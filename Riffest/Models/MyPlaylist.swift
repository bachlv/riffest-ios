import Foundation
import UIKit
import Realm
import RealmSwift

class MyPlaylistDownloaded: Object{
    
    @objc dynamic var myPlaylistID = UUID().uuidString
    override static func primaryKey() -> String? {
        return "myPlaylistID"
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var followers: Int = 0
    @objc dynamic var status: Int = 0
    @objc dynamic var tracks: Int = 0

}


class RMMyPlaylist: NSObject {
    
    var id: Int?
    var title: String?
    var poster: String?
    var status: Int?
    var tracks: Int?
    var followers: Int?
    var name: String?
    
    override init() {
        super.init()
    }
    init(withDictionary dic: NSDictionary) {
        self.id = dic.value(forKey: "id") as? Int
        self.title = dic.value(forKey: "title") as? String ?? ""
        self.poster = dic.value(forKey: "poster") as? String ?? ""
        self.status = dic.value(forKey: "status") as? Int
        self.tracks = dic.value(forKey: "tracks") as? Int
        self.followers = dic.value(forKey: "followers") as? Int
        self.name = dic.value(forKey: "name") as? String ?? ""
    }
}


