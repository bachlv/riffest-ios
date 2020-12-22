import UIKit
import FBSDKLoginKit
import GoogleSignIn

class LoginCell: UICollectionViewCell, LoginButtonDelegate, GIDSignInDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "LaunchScreen")
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var customFBButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width - 40, height: 55))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Login with Facebook", for: .normal)
        button.titleLabel?.font = AppStateHelper.shared.defaultFontBold(size: 16)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        
        return button
    }()
    lazy var customGButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width - 40, height: 55))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  Login with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppStateHelper.shared.defaultFontBold(size: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    weak var delegate: LoginControllerDelegate?
    let gradient:CAGradientLayer = CAGradientLayer()
    let gradientfb:CAGradientLayer = CAGradientLayer()
    
    
    fileprivate func setupGoogleButtons() {
        addSubview(customGButton)
        customGButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        customGButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        customGButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        customGButton.bottomAnchor.constraint(equalTo: self.customFBButton.bottomAnchor, constant: 70).isActive = true
        let colorTop = UIColor.rgb(64, green: 129, blue: 263, alpha: 1.0).cgColor
        let colorBottom = UIColor.rgb(80, green: 150, blue: 220, alpha: 1.0).cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.frame = customGButton.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = 5
        customGButton.layer.insertSublayer(gradient, at:0)
        customGButton.setImage(UIImage(named:"google"), for: .normal)
        customGButton.imageView?.layer.zPosition = 1
        customGButton.addTarget(self, action: #selector(handleCustomGoogleSign), for: .touchUpInside)
    }
    
    @objc func handleCustomGoogleSign() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()        
    }
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if (error == nil) {
            let body = ["name": "\(user.profile.name!)",
                "email": "\(user.profile.email!)",
                "type_social": "google",
                "social_id": "\(user.userID!)",
                "profile": "\(user.profile.imageURL(withDimension: 500)!)"] as [String : Any]
            DispatchQueue.main.async {
                self.customGButton.isHidden = true
                self.customFBButton.isHidden = true
                AppStateHelper.shared.onHandleShowIndicator()
                
            }
            RMService.onHandleLogin(body as! Dictionary<String, String>,onSuccess: { loged in  })
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    fileprivate func setupFacebookButtons() {
        addSubview(customFBButton)
        customFBButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        customFBButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        customFBButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        customFBButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40).isActive = true
        let colorTop = UIColor.rgb(60, green: 102, blue: 190, alpha: 1.0).cgColor
        let colorBottom = UIColor.rgb(80, green: 120, blue: 225, alpha: 1.0).cgColor
        gradientfb.colors = [colorTop, colorBottom]
        gradientfb.frame = customFBButton.bounds
        gradientfb.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientfb.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientfb.cornerRadius = 5
        customFBButton.layer.insertSublayer(gradientfb, at:0)
        customFBButton.setImage(UIImage(named:"facebook"), for: .normal)
        customFBButton.imageView?.layer.zPosition = 1
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
    }
    @objc func handleCustomFBLogin() {
        LoginManager().logIn(permissions: ["email"], from: LoginController.sharedController) { (result, err) in
            if err != nil {
                print("FB Login failed")
                return
            }
            let accessToken = AccessToken.current
            if(accessToken == nil){
                return
            }
            GraphRequest(graphPath: "me", parameters: ["fields": "id,name,email, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbDetails = result as? [String: Any]
                    if let picture = fbDetails!["picture"] as? [String: Any] {
                        if let data = picture["data"] as? [String: Any] {
                            if let url = data["url"] {
                                let body = ["name": fbDetails!["name"]!,
                                            "email": fbDetails!["email"]!,
                                            "type_social": "facebook",
                                            "social_id": fbDetails!["id"]!,
                                            "profile": url] as! Dictionary<String, String>
                                DispatchQueue.main.async {
                                    self.customGButton.isHidden = true
                                    self.customFBButton.isHidden = true
                                    AppStateHelper.shared.onHandleShowIndicator()
                                }
                                RMService.onHandleLogin(body,onSuccess: { loged in  })
                            }
                        }
                    }
                }else{
                    print(error?.localizedDescription ?? "Not found")
                }
            })
        }
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.anchorToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        setupFacebookButtons()
        setupGoogleButtons()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}








