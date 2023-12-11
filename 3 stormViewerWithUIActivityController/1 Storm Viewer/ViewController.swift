//
//  ViewController.swift
//  1 Storm Viewer
//
//  Created by Taha Saleh on 4/23/22.
//

import UIKit

class TableViewController: UITableViewController
{
    var pictures = FileManager.default.appendImages()
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    
    
  override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return pictures.count
   }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let cellTitle = pictures[indexPath.row]
    var config = cell.defaultContentConfiguration()
    config.text = cellTitle
    config.image = UIImage(systemName: "photo")
    cell.contentConfiguration = config
    return cell
   }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.selectedImage = pictures[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
}

