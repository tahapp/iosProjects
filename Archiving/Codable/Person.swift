//
//  Person.swift
//  12 UserDefaults 2
//
//  Created by Taha Saleh on 7/30/22.
//

import Foundation

class Person : NSObject,Codable
{
    
    
    var name:String
    var image:String
    
    init(name:String,image:String)
    {
        self.name = name
        self.image = image
    }
    
}
