//
//  DetailViewController.swift
//  1 Storm Viewer
//
//  Created by Taha Saleh on 4/26/22.
//

import UIKit

class DetailViewController: UIViewController
{
    var imageView = UIImageView()
    var selectedImage:String?
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .systemBackground
        self.view = v
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = selectedImage
       
        if let imageToLoad = selectedImage
        {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: imageToLoad)
            view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                imageView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
                imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10),
                imageView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10)
            ])
           
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.hidesBarsOnTap = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.hidesBarsOnTap = false
//    }
}
