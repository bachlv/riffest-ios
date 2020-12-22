import Foundation
import UIKit

public var baseUrl = "https://riffest.herokuapp.com/api/"
public var webUrl = "https://riffest.herokuapp.com/"

var alermsg = "We apologise for a system error! Please try again later."
var userAuth = UserDefaults.standard.value(forKey: "userAuth") as? [String: Any]

class RMService {
    
    var customTabBarController: CustomTabBarController?

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
 
    class func onHandleGetData(_ url: String, _ onSuccess: @escaping (
        _ featured: [RMMyPlaylist],
        _ top: [RMSong],
        _ genre: [RMGenre],
        _ release: [RMSong],
        _ artist: [RMArtists],
        _ playlist: [RMMyPlaylist]
        
        ) -> (), onError: @escaping (_ errorMessage: String) -> ()) {
        let urlString = baseUrl+url
        RMService.baseRequest(withURL: urlString, onSuccess: { (data) in
            var featured: [RMMyPlaylist] = []
            var top: [RMSong] = []
            var genre: [RMGenre] = []
            var release: [RMSong] = []
            var artist: [RMArtists] = []
            var playlist: [RMMyPlaylist] = []
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    if let songDic = json.value(forKey: "featured") as? [NSDictionary] {
                        for dic in songDic {
                            let featureds = RMMyPlaylist.init(withDictionary: dic)
                            featured.append(featureds)
                        }
                    }
                    if let songDic = json.value(forKey: "top") as? [NSDictionary] {
                        for dic in songDic {
                            let tops = RMSong.init(withDictionary: dic)
                            top.append(tops)
                        }
                    }
                    if let songDic = json.value(forKey: "genre") as? [NSDictionary] {
                        for dic in songDic {
                            let genres = RMGenre.init(withDictionary: dic)
                            genre.append(genres)
                        }
                    }
                    if let songDic = json.value(forKey: "release") as? [NSDictionary] {
                        for dic in songDic {
                            let releases = RMSong.init(withDictionary: dic)
                            release.append(releases)
                        }
                    }
                    if let songDic = json.value(forKey: "top_artist") as? [NSDictionary] {
                        for dic in songDic {
                            let artists = RMArtists.init(withDictionary: dic)
                            artist.append(artists)
                        }
                    }
                    if let songDic = json.value(forKey: "featured_playlists") as? [NSDictionary] {
                        for dic in songDic {
                            let playlists = RMMyPlaylist.init(withDictionary: dic)
                            playlist.append(playlists)
                        }
                    }

                    onSuccess(featured,top,genre,release,artist,playlist)
                }
            }catch {
                DispatchQueue.main.async {
                 // AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                }
            }
        }) { (errorString) in
            onError(errorString)
        }
    }
    // onw user get all playlist
    class func onHandleGetMyPlaylist(_ url: String, _ onSuccess: @escaping (_ myplaylist: [RMMyPlaylist]) -> (), onError: @escaping (_ errorMessage: String) -> ()) {
        let urlString = baseUrl+url
        RMService.baseRequest(withURL: urlString, onSuccess: { (data) in
            var myplaylist: [RMMyPlaylist] = []
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                    if let songDic = json.value(forKey: "data") as? [NSDictionary] {
                        for dic in songDic {
                            let myplaylists = RMMyPlaylist.init(withDictionary: dic)
                            myplaylist.append(myplaylists)
                        }
                        onSuccess(myplaylist)
                    }
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
    // add new song to my playlist 
    class func onHandlePostPlaylist(_ url: String,_ Method: String, _ body: Dictionary<String, String>, onSuccess: @escaping (_ playlist: Bool) -> () ){
        let session = URLSession.shared
        let ulrString =  NSURL(string: baseUrl + url)
        var request = URLRequest(url:  ulrString! as URL)
        let userToken = UserDefaults.standard.value(forKey: "token")
        if  userToken != nil {
            request.setValue("Bearer \(String(describing:userToken!))", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = Method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error)
            DispatchQueue.main.async {
                AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                return
            }
            if data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        onSuccess(true)
                    }else {
                        onSuccess(false)
                    }
                }
            }
        })
        task.resume()
    }
    
    class func onHandleLogin(_ body: Dictionary<String, String>, onSuccess: @escaping (_ logged: Bool) -> () ){
        print("body", body)
        let session = URLSession.shared
        let ulr =  NSURL(string: baseUrl+"login" as String)
        var request = URLRequest(url:  ulr! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print(error)
            DispatchQueue.main.async {
                AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
            }
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("httpResponse", httpResponse)
                if httpResponse.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                            if let userDic = json["data"] as? [String: Any] {
                                UserDefaults.standard.set(userDic, forKey: "userAuth")
                                UserDefaults.standard.set(json["token"]!, forKey: "token")
                                UserDefaults.standard.synchronize()
                            }
                            AppStateHelper.shared.handleRequestDataHome()
                            onSuccess(true)
                        }
                    }catch let error {
                        print(error)
                        DispatchQueue.main.async {
                            AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                        }
                    }
                }else {
                    DispatchQueue.main.async {
                        AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                    }
                }
            }
        })
        task.resume()
    }
    

    
}

