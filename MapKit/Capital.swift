//
//  Capital.swift
//  16 capitalCities
//
//  Created by Taha Saleh on 10/20/22.
//

import MapKit

class Capital : NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate:CLLocationCoordinate2D,title:String,subtitle:String)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
