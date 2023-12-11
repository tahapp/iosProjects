
import UIKit

class ViewController: UITableViewController
{
    private var petitions : [Petition] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        
       
        let url : String
        if navigationController?.tabBarItem.tag == 0
        {
             url = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else{
            
            url =  "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let jsonURL = URL(string: url)
        {
            
           if let jsonData = try? Data(contentsOf: jsonURL)
            {
                parse(json: jsonData)
                return
            }
        }
        showError()
    }
    func showError()
    {
        let ac = UIAlertController(title: "loading error", message: "check network connection", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    func parse(json:Data)
    {
        let decoder = JSONDecoder()
        if let realData = try? decoder.decode(Petitions.self, from: json){
            
            petitions = realData.results
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "petition", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = petitions[indexPath.row].title
        config.secondaryText = petitions[indexPath.row].body
        config.secondaryTextProperties.numberOfLines = 1
        config.secondaryTextProperties.lineBreakMode = .byTruncatingTail
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController{
            vc.petition = petitions[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


