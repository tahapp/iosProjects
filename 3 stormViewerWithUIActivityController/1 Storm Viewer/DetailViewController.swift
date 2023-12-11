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
        navigationItem.titleView  = {
            let label = UILabel()
            label.text = selectedImage
            label.textColor = UIColor(red: 0.3, green: 0.25, blue: 0.89, alpha: 0.90)

            label.font = .boldSystemFont(ofSize: 20)
            return label
        }()
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad = selectedImage
        {
            imageView.image = UIImage(named: imageToLoad)
            imageView.contentMode = .scaleToFill
           
        }
        
        view.addSubview(imageView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    override func viewDidLayoutSubviews() {
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func share()
    {
        guard let dataImage = imageView.image?.jpegData(compressionQuality: 1.0)else{
            return
        }
        let ac = UIActivityViewController(activityItems: [dataImage], applicationActivities: [])
        present(ac, animated: true)
    }
}
