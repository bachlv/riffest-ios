import Foundation
import UIKit
import SDWebImage

protocol SliderDelegate: NSObjectProtocol {
    func sbslider(_ sbslider: SliderViews, didTapOn targetImage: UIImage, andParentView targetView: UIImageView)
}

class SliderViews: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    static let sharedController = SliderViews()
    
    
    var featured: [RMMyPlaylist] = []
    var autoSrcollEnabled:Bool = true
    var activeTimer:Timer?
    
    weak var _delegate:SliderDelegate?
    weak var delegate:SliderDelegate?
    
    var sliderMainScroller = UIScrollView()
    let pageIndicator = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pageIndicator.pageIndicatorTintColor = UIColor.white
        pageIndicator.currentPageIndicatorTintColor = UIColor.themeBaseColor()
        sliderMainScroller.frame = CGRect(x:0,y:0, width: UIScreen.main.bounds.width, height: 200)
        sliderMainScroller.showsHorizontalScrollIndicator = false
        sliderMainScroller.showsVerticalScrollIndicator = false
        self.addSubview(sliderMainScroller)
        self.addSubview(pageIndicator)
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageIndicator.centerXAnchor.constraint(equalTo: self.sliderMainScroller.centerXAnchor),
            pageIndicator.heightAnchor.constraint(equalToConstant: 30),
            pageIndicator.widthAnchor.constraint(equalToConstant: 100),
            pageIndicator.bottomAnchor.constraint(equalTo: self.sliderMainScroller.bottomAnchor, constant: 7),
            ])
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func createSlider(withImages images: [Any], withAutoScroll isAutoScrollEnabled: Bool, in parentView: UIView) {
        self.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.size.width), height: CGFloat(UIScreen.main.bounds.size.height))
        featured = images as! [RMMyPlaylist]
        autoSrcollEnabled = isAutoScrollEnabled
        sliderMainScroller.isPagingEnabled = true
        sliderMainScroller.delegate = self
        pageIndicator.numberOfPages = featured.count
        sliderMainScroller.contentSize = CGSize(width:CGFloat(UIScreen.main.bounds.size.width*3*(CGFloat(featured.count))), height:CGFloat(sliderMainScroller.frame.size.height))
        
        var mainCount: Int = 0
        for _ in 0..<3 {
            for i in 0..<featured.count {
                var ImageViewFrameRect = CGRect.zero
                ImageViewFrameRect.origin.y = 0
                ImageViewFrameRect.size.width = UIScreen.main.bounds.size.width
                ImageViewFrameRect.size.height = UIScreen.main.bounds.size.height/2 - 60
                ImageViewFrameRect.origin.x = (ImageViewFrameRect.size.width * CGFloat(mainCount))
                let imageVIew = UIView(frame: CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height))
                imageVIew.frame = ImageViewFrameRect
                self.sliderMainScroller.addSubview(imageVIew)
                let imageV = UIImageView(frame: UIScreen.main.bounds)
                imageV.clipsToBounds = true
                imageV.contentMode =  UIView.ContentMode.scaleAspectFill
                imageV.translatesAutoresizingMaskIntoConstraints = false
                imageVIew.addSubview(imageV)
                NSLayoutConstraint.activate([
                    imageV.leadingAnchor.constraint(equalTo: imageVIew.leadingAnchor),
                    imageV.trailingAnchor.constraint(equalTo: imageVIew.trailingAnchor),
                    imageV.topAnchor.constraint(equalTo: imageVIew.topAnchor),
                    imageV.bottomAnchor.constraint(equalTo: imageVIew.bottomAnchor),
                    ])
                imageV.isUserInteractionEnabled = true
                imageV.sd_setImage(with: URL(string:  featured[i].poster!)!, placeholderImage: UIImage(named: "thumbnailbig"))
                let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(self.tapOnImage))
                tapOnImage.delegate = self
                tapOnImage.numberOfTapsRequired = 1
                imageV.addGestureRecognizer(tapOnImage)
                
                var disFrameRect = CGRect.zero
                disFrameRect.origin.y = 150
                disFrameRect.size.width = UIScreen.main.bounds.size.width
                disFrameRect.size.height = 60
                disFrameRect.origin.x = (disFrameRect.size.width * CGFloat(mainCount))
                
                let featuredUIView = UIView()
                featuredUIView.frame = disFrameRect
                featuredUIView.backgroundColor = UIColor.rgb(21, green: 22, blue: 24, alpha: 0.6)
                self.sliderMainScroller.addSubview(featuredUIView)
                
                var labelFrameRect = CGRect.zero
                labelFrameRect.origin.y = 155
                labelFrameRect.size.width = UIScreen.main.bounds.size.width
                labelFrameRect.size.height = 30
                labelFrameRect.origin.x = (labelFrameRect.size.width * CGFloat(mainCount)) + 15
                
                let buttonTitle = UIButton()
                buttonTitle.frame = labelFrameRect
                buttonTitle.titleLabel?.font = AppStateHelper.shared.defaultFontRegular(size:17)
                buttonTitle.contentHorizontalAlignment = .left
                buttonTitle.tintColor = UIColor.white
                buttonTitle.setTitle(featured[i].title, for: .normal)
                buttonTitle.tag = i
                buttonTitle.addTarget(self, action: #selector(handleMore(sender:)), for: .touchUpInside)
                self.sliderMainScroller.addSubview(buttonTitle)
                mainCount += 1
            }
        }
        
        let startX = CGFloat(featured.count) * UIScreen.main.bounds.size.width
        sliderMainScroller.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        if (featured.count > 1) && (isAutoScrollEnabled) {
            self.startTimerThread()
        }
        
    }
    
    @objc func handleMore(sender: UIButton){
        HomeController.sharedController.onHandleGoToPlaylistFeature(playlist: featured, indexPath: sender.tag)
     
    }
    @objc func tapOnImage(gesture: UITapGestureRecognizer){
        let targetView: UIImageView? = (gesture.view as? UIImageView)
        _delegate?.sbslider(self , didTapOn: (targetView?.image)!, andParentView: targetView!)
        
    }
    
    //#pragma mark - UIScrollView delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.size.width
        let page: Int = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        var moveToPage: Int = page
        if moveToPage == 0 {
            moveToPage = featured.count
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        else if moveToPage == ((featured.count * 3) - 1) {
            moveToPage = featured.count - 1
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        
        if moveToPage < featured.count {
            pageIndicator.currentPage = moveToPage
        }
        else {
            moveToPage = moveToPage % featured.count
            pageIndicator.currentPage = moveToPage
        }
        if (featured.count > 1) && (autoSrcollEnabled) {
            self.startTimerThread()
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let width: CGFloat = scrollView.frame.size.width
        let page: Int = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        var moveToPage: Int = page
        if moveToPage == 0 {
            moveToPage = featured.count
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        else if moveToPage == ((featured.count * 3) - 1) {
            moveToPage = featured.count - 1
            let startX = CGFloat(moveToPage) * UIScreen.main.bounds.size.width
            scrollView.setContentOffset(CGPoint(x: startX, y: CGFloat(0)), animated: false)
        }
        
        if moveToPage < featured.count {
            pageIndicator.currentPage = moveToPage
        }
        else {
            moveToPage = moveToPage % featured.count
            pageIndicator.currentPage = moveToPage
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if((activeTimer) != nil){
            activeTimer?.invalidate()
            activeTimer = nil
        }
    }
    //pragma mark end
    @objc func slideImage(){
        
        var startX: CGFloat = 0.0
        let width: CGFloat = sliderMainScroller.frame.size.width
        let page: Int = Int((sliderMainScroller.contentOffset.x + (0.5 * width)) / width)
        let nextPage: Int = page + 1
        startX = CGFloat(nextPage) * width
        
        sliderMainScroller .setContentOffset(CGPoint(x:startX, y:0), animated: true)
    }
    
    func startTimerThread(){
        if((activeTimer) != nil){
            activeTimer?.invalidate()
            activeTimer = nil
        }
        
        activeTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.slideImage), userInfo: nil, repeats: true)
        
    }
    
    func startAutoPlay() {
        autoSrcollEnabled = true
        if(featured.count > 1 && autoSrcollEnabled){
            self .startTimerThread()
        }
    }
    
    func stopAutoPlay() {
        autoSrcollEnabled =  false
        if((activeTimer) != nil){
            activeTimer?.invalidate()
            activeTimer = nil
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

