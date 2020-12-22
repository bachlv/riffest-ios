import UIKit

class UserPlaylistController: UITableViewController {
    
    static var sharedController = UserPlaylistController()
    
    fileprivate let cellId = "cellId"
    
    private func setupView(){
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserPlaylistController.sharedController = self
        self.view.backgroundColor = .white
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension UserPlaylistController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
    
}
