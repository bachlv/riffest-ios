import UIKit
import WebKit

class PagesController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var urlString: String = ""
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadView()
        loadWebView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadWebView(){
        DispatchQueue.main.async {
            AppStateHelper.shared.onHandleShowIndicator()
            self.webView.load(URLRequest(url: URL(string: webUrl + self.urlString)!))
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail navigating to url")
        DispatchQueue.main.async {
            AppStateHelper.shared.onHandleHideIndicator()
            AppStateHelper.shared.onHandleAlertNotifiError(title: alermsg)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            AppStateHelper.shared.onHandleHideIndicator()
        }
    }
    
}
