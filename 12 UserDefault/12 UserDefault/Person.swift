//
//  Person.swift
//  12 UserDefault
//
//  Created by Taha Saleh on 7/29/22.
//



import Foundation


class Person : NSObject , NSCoding
{
    
    
    var name:String
    var image:String
    
    init(name:String,image:String)
    {
        self.name = name
        self.image = image
    }
    
    func encode(with coder: NSCoder)
    {
        coder.encode(name,forKey: "name")
        coder.encode(image,forKey: "image")
    }
    
    required init?(coder: NSCoder)
    {
        name = coder.decodeObject(forKey: "name") as? String ?? "name"
        image = coder.decodeObject(forKey: "image") as? String ?? "image"
    }
}
