import Foundation
import UIKit

class SearchService {
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
    class func onHandleGetSearch(_ url: String, _ onSuccess: @escaping (
        _ song: [RMSong],
        _ artist: [RMArtists],
        _ playlist: [RMMyPlaylist],
        _ album: [RMAlbum]
        
        ) -> (), onError: @escaping (_ errorMessage: String) -> ()) {
        let urlString = baseUrl+url
        SearchService.baseRequest(withURL: urlString, onSuccess: { (data) in
            var song: [RMSong] = []
            var artist: [RMArtists] = []
            var playlist: [RMMyPlaylist] = []
            var album: [RMAlbum] = []
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    if let songDic = json.value(forKey: "songs") as? [NSDictionary] {
                        for dic in songDic {
                            let songs = RMSong.init(withDictionary: dic)
                            song.append(songs)
                        }
                    }
                    if let songDic = json.value(forKey: "artist") as? [NSDictionary] {
                        for dic in songDic {
                            let artists = RMArtists.init(withDictionary: dic)
                            artist.append(artists)
                        }
                    }
                    if let songDic = json.value(forKey: "playlists") as? [NSDictionary] {
                        for dic in songDic {
                            let playlists = RMMyPlaylist.init(withDictionary: dic)
                            playlist.append(playlists)
                        }
                    }
                    if let songDic = json.value(forKey: "albums") as? [NSDictionary] {
                        for dic in songDic {
                            let albums = RMAlbum.init(withDictionary: dic)
                            album.append(albums)
                        }
                    }
                    onSuccess(song,artist,playlist,album)
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
