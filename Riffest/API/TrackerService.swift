import Foundation
import UIKit

class TrackerService {
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
    
    class func onHandleTracker(_ url: String,_ Method: String, _ body: Dictionary<String, String>, onSuccess: @escaping (_ success: Bool) -> () ){
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
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                return
            }
            if data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("suucess")
                        onSuccess(true)
                    }else {
                        onSuccess(false)
                    }
                }
            }
        })
        task.resume()
    }
    
    class func onHandleTrackerRemove(_ url: String,_ Method: String, _ body: Dictionary<String, [Int]>, onSuccess: @escaping (_ success: Bool) -> () ){
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
                        print("suucess")
                        onSuccess(true)
                    }else {
                        DispatchQueue.main.async {
                            AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
                        }
                        onSuccess(false)
                    }
                }
            }
        })
        task.resume()
    }
    
    
    
}
