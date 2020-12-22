import UIKit
class PhotoManager: NSObject {
    
    func initializePhotoViewer(fromViewControlller fromViewController: Any, forTargetImageView targetImageView: UIImageView, withPosition startPosition: CGRect) {
        
        let appDel: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        if (fromViewController is UIViewController) {
            var backgroundImage: UIImage? = nil
            let targetViewController: UIViewController? = (fromViewController as? UIViewController)
            let scale = "scale"
            if UIScreen.main.responds(to: Selector(scale)) {
                UIGraphicsBeginImageContextWithOptions((appDel?.window?.bounds.size)!, false, UIScreen.main.scale)
            }
            else {
                UIGraphicsBeginImageContext((appDel?.window?.bounds.size)!)
            }
            appDel?.window?.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imgData: Data? = image!.pngData()
            if imgData != nil {
                backgroundImage = UIImage(data: imgData!)
            }
            else {
                print("error while taking screenshot")
            }
            
            let photoViewer = PhotoViewController.sharedController
            photoViewer.targetImage = targetImageView.image
            photoViewer.initialRect = startPosition
            photoViewer.backGroundImage = backgroundImage
            targetViewController?.navigationController?.pushViewController(photoViewer, animated: false)
        }
        else{
            //UIAlert
        }
        
    }
}
