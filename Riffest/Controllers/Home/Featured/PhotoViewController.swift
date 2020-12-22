import UIKit

let kMinBlackMaskAlpha: CGFloat = 0.1

class PhotoViewController: UIViewController {
    static var sharedController = PhotoViewController()
    
    var initialRect = CGRect.zero
    var targetImage: UIImage!
    var backGroundImage: UIImage!
    
    var maskView = UIView()
    var backGroundImageView = UIImageView()
    
    var mainImageView: UIImageView!
    var _finalRect: CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoViewController.sharedController = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        maskView.frame = CGRect(x:0,y:0,width: UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        backGroundImageView.frame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        maskView.backgroundColor = UIColor.red
        self.view.addSubview(maskView)
        maskView.addSubview(backGroundImageView)
        self.setupBackGround()
        self.setUpImageViewer()
    }
    
    func setupBackGround(){
        backGroundImageView.image = backGroundImage
        backGroundImageView.contentMode = .scaleAspectFill
        backGroundImageView.clipsToBounds = true
    }
    
    func setUpImageViewer(){
        mainImageView = UIImageView(frame: initialRect)
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.image = targetImage
        mainImageView.clipsToBounds = true
        self.view.addSubview(mainImageView)
        
        
        var mainImageViewFrame: CGRect = self .getFullSizeFrameWithView(targetImageView: mainImageView)
        let targetY: CGFloat? = (((mainImageView.superview?.frame.size.height)! - mainImageViewFrame.size.height) / 2.0)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.maskView.alpha = 1.0
            mainImageViewFrame.origin.x = 0.0
            mainImageViewFrame.origin.y = targetY!
            self.mainImageView.frame = mainImageViewFrame
        }, completion: {(_ finished: Bool) -> Void in
            self.setupGesture()
            self._finalRect = mainImageViewFrame
        })
    }
    
    func getFullSizeFrameWithView(targetImageView:UIImageView) -> CGRect{
        let tempImage: UIImage? = targetImageView.image
        let imageFrame: CGSize? = tempImage?.size
        var finalFullFrame: CGRect = targetImageView.frame
        
        
        if (imageFrame?.width)! > (imageFrame?.height)! {
            finalFullFrame.size.width = UIScreen.main.bounds.size.width
            let multiplier: CGFloat = imageFrame!.width / imageFrame!.height
            finalFullFrame.size.height = finalFullFrame.size.width / multiplier
        }
            
        else if ((imageFrame?.height)! > (imageFrame?.width)!) {
            finalFullFrame.size.height = UIScreen.main.bounds.size.width
            let multiplier: CGFloat = imageFrame!.width / imageFrame!.height
            finalFullFrame.size.height = finalFullFrame.size.width / multiplier
        }
        else{
            finalFullFrame.size.height = UIScreen.main.bounds.size.width
            finalFullFrame.size.height = UIScreen.main.bounds.size.width
        }
        
        return finalFullFrame
        
    }
    
    func setupGesture(){
        mainImageView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.imageViewDidPan))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        mainImageView.addGestureRecognizer(panGesture)
        
    }
    
    @objc func imageViewDidPan(recognizer: UIPanGestureRecognizer){
        let translation: CGPoint = recognizer.translation(in: self.view)
        var recognizerFrame: CGRect = recognizer.view!.frame
        recognizerFrame.origin.x += translation.x
        recognizerFrame.origin.y += translation.y
        
        let displacement: CGFloat = fabs((recognizerFrame.origin.y + mainImageView.frame.size.height / 2) - UIScreen.main.bounds.size.height / 2)
        maskView.alpha = max(1 - displacement / (UIScreen.main.bounds.size.height / 0.9), kMinBlackMaskAlpha)
        recognizer.view?.frame = recognizerFrame
        
        if(recognizer.state == UIGestureRecognizer.State.ended){
            self.animationDidFinish(endRect: recognizerFrame.origin)
        }
        recognizer .setTranslation(CGPoint(x:0.0, y:0.0), in: self.view)
    }
    
    func animationDidFinish (endRect: CGPoint){
        var displacement: CGFloat = _finalRect.origin.y - endRect.y
        if(displacement < 0){
            displacement = -(displacement)
        }
        
        if displacement <= 60.0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.mainImageView.frame = self._finalRect
                self.maskView.alpha = 1.0
            }, completion: { _ in })
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.mainImageView.frame = self.initialRect
            }, completion: {(_ finished: Bool) -> Void in
                self.navigationController?.popViewController(animated: false)
            })
        }
    }
}
