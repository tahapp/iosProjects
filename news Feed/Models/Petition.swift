//
//  Petition.swift
//  7 white house petition
//
//  Created by Taha Saleh on 6/9/22.
//

import Foundation
struct Petition : Decodable
{
    var title:String
    var body:String
    var signatureCount:Int
}
