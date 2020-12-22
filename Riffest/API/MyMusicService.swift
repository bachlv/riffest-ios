import Foundation
import UIKit
import RealmSwift

class MyMusicService {
    class fileprivate func baseRequest(withURL urlString: String, onSuccess: @escaping (_ data: Data?) -> (), onError: @escaping (_ errorMessage: String) -> ()) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let userToken = UserDefaults.standard.value(forKey: "token")
        let safeURL = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        var urlRequest = URLRequest(url: URL(string: safeURL!)!)
        if  userToken != nil {
            urlRequest.setValue("Bearer \(String(describing:userToken!))", forHTTPHeaderField: "Authorization")
        }
        let session = URLSession.shared
        DispatchQueue.main.async {
            let dataTask = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                if error != nil {
                    onError("\(error!)")
                }else {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    if statusCode == 200 {
                        onSuccess(data)
                    }else {
                        let statusCodeObj = HTTPStatusCode.init(statusCode: statusCode)
                        onError(statusCodeObj.statusDescription)
                    }
                }
            })
            dataTask.resume()
        }
    }
    // get my music artist playlist view
    class func onHandleGetMyMusic(_ url: String, _ onSuccess: @escaping (
        _ song: [RMSong],
        _ artist: [RMArtists],
        _ playlist: [RMMyPlaylist],
        _ album: [RMAlbum]
        
        ) -> (), onError: @escaping (_ errorMessage: String) -> ()) {
        let urlString = baseUrl+url
        MyMusicService.baseRequest(withURL: urlString, onSuccess: { (data) in
            let song: [RMSong] = []
            var artist: [RMArtists] = []
            var playlist: [RMMyPlaylist] = []
            var album: [RMAlbum] = []
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    if let songDic = json.value(forKey: "artist") as? [NSDictionary] {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.delete(realm.objects(ArtistDownloaded.self))
                        }
                        for dic in songDic {
                            let artistsObject = ArtistDownloaded()
                            artistsObject.id = dic["id"] as! Int
                            artistsObject.artistID = String(describing: dic["id"] ?? "")
                            artistsObject.name = (dic["name"] as? String)!
                            artistsObject.poster = (dic["poster"] as? String)!
                            try! realm.write {
                                realm.add(artistsObject)
                            }
                            let artists = RMArtists.init(withDictionary: dic)
                            artist.append(artists)
                        }
                    }
                    if let songDic = json.value(forKey: "playlist") as? [NSDictionary] {
                        let realm = try! Realm()
                        try! realm.write {
                            realm.delete(realm.objects(MyPlaylistDownloaded.self))
                        }
                        for dic in songDic {
                            let myPlaylistObject = MyPlaylistDownloaded()
                            myPlaylistObject.id = dic["id"] as! Int
                            myPlaylistObject.myPlaylistID = String(describing: dic["id"] ?? "")
                            myPlaylistObject.title = (dic["title"] as? String)!
                            myPlaylistObject.poster = (dic["poster"] as? String)!
                            myPlaylistObject.name = (dic["name"] as? String)!
                            myPlaylistObject.status = dic["status"] as! Int
                            myPlaylistObject.tracks = dic["tracks"] as! Int
                          //  myPlaylistObject.followers = dic["followers"] as! Int
                            try! realm.write {
                                realm.add(myPlaylistObject)
                            }
                            
                            let playlists = RMMyPlaylist.init(withDictionary: dic)
                            playlist.append(playlists)
                        }
                    }
                    if let songDic = json.value(forKey: "album") as? [NSDictionary] {
                        
                        let realm = try! Realm()
                        try! realm.write {
                            realm.delete(realm.objects(AlbumDownloaded.self))
                        }
                        for dic in songDic {
                            let albumObject = AlbumDownloaded()
                            albumObject.id = dic["id"] as! Int
                            albumObject.albumID = String(describing: dic["id"] ?? "")
                            albumObject.title = (dic["title"] as? String)!
                            albumObject.poster = (dic["poster"] as? String)!
                            try! realm.write {
                                realm.add(albumObject)
                            }
                            let albums = RMAlbum.init(withDictionary: dic)
                            album.append(albums)
                        }
                    }
                    onSuccess(song, artist,playlist, album)
                }
            }catch {
                DispatchQueue.main.async {
                    AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                }
            }
        }) { (errorString) in
            onError(errorString)
        }
    }
    
    
  
    
}
