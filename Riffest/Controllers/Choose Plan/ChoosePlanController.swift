import UIKit

class ChoosePlanController: UIViewController {
    
    public static var sharedController = ChoosePlanController()

    private func setupView(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onHandleCancel))
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ChoosePlanController.sharedController = self
        navigationItem.title = "Riffest Music"
        self.view.backgroundColor = .white
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onHandleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}

