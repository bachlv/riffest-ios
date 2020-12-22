import UIKit
import Foundation
import Realm
import RealmSwift

import Realm
import RealmSwift

class MyTrackDownloaded: Object{
    
    @objc dynamic var songID = UUID().uuidString
    override static func primaryKey() -> String? {
        return "songID"
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var artist_name: String = ""
    @objc dynamic var picture: String = ""
    @objc dynamic var album_id: Int = 0
    @objc dynamic var artistId: Int = 0
    @objc dynamic var playlist_song_id: Int = 0
    @objc dynamic var song_download_id: Int = 0
    @objc dynamic var songs_counter_id: Int = 0
    
}

class SongDownloaded: Object{

    @objc dynamic var songID = UUID().uuidString
    override static func primaryKey() -> String? {
        return "songID"
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var artist_name:String = ""
    @objc dynamic var album_id: Int = 0
    @objc dynamic var artistId: Int = 0
    @objc dynamic var playlist_song_id: Int = 0
    @objc dynamic var song_download_id: Int = 0
    @objc dynamic var songs_counter_id: Int = 0
    
    
}

class SongDownloading: Object{
    
    @objc dynamic var songID = UUID().uuidString
    override static func primaryKey() -> String? {
        return "songID"
    }
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var poster: String = ""
    @objc dynamic var picture: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var artist_name:String = ""
    @objc dynamic var album_id: Int = 0
    @objc dynamic var artistId: Int = 0
    @objc dynamic var playlist_song_id: Int = 0
    @objc dynamic var song_download_id: Int = 0
    @objc dynamic var songs_counter_id: Int = 0
    
}

class RMSong: NSObject {
    var id: Int?
    var title: String?
    var poster: String?
    var url: String?
    var status: Int?
    var duration: String?
    var artist_name: String?
    var picture: String?
    var artistId: Int?
    var views: String?
    
    var album_title: String?
    var album_id: Int?
    var album_poster: String?
    
    var playlist_song_id: Int?
    var song_download_id: Int?
    var songs_counter_id: Int?
    var history_id: Int?
    
    override init() {
        super.init()
    }
    
    init(withDictionary dic: NSDictionary) {
        self.id = dic.value(forKey: "id") as? Int
        self.title = dic.value(forKey: "title") as? String ?? ""
        self.poster = dic.value(forKey: "poster") as? String ?? ""
        self.url = dic.value(forKey: "url") as? String ?? ""
        self.status = dic.value(forKey: "status") as? Int
        self.duration = dic.value(forKey: "duration") as? String ?? ""
        self.artist_name = dic.value(forKey: "artist_name") as? String ?? ""
        self.picture = dic.value(forKey: "picture") as? String ?? ""
        self.artistId = dic.value(forKey: "artistId") as? Int
        self.views = dic.value(forKey: "views") as? String ?? ""
        
        self.album_title = dic.value(forKey: "album_title") as? String ?? ""
        self.album_id = dic.value(forKey: "album_id") as? Int
        self.album_poster = dic.value(forKey: "album_poster") as? String ?? ""
      
        self.playlist_song_id = dic.value(forKey: "playlist_song_id") as? Int
        self.song_download_id = dic.value(forKey: "song_download_id") as? Int
        self.songs_counter_id = dic.value(forKey: "songs_counter_id") as? Int
        self.history_id = dic.value(forKey: "history_id") as? Int

    }
}


