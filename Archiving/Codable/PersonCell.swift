//
//  PersonCell.swift
//  12 UserDefaults 2
//
//  Created by Taha Saleh on 7/30/22.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var labelName = UILabel()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.textAlignment = .left
     
        labelName.adjustsFontSizeToFitWidth = true
        contentView.addSubview(imageView)
        contentView.addSubview(labelName)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            imageView.heightAnchor.constraint(equalToConstant:120),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -5),
            
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 5),
            labelName.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            labelName.heightAnchor.constraint(equalToConstant: 40),
            labelName.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -5)
            
        ])
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
       
    }
    
}

