//
//  ViewController.swift
//  16 capitalCities
//
//  Created by Taha Saleh on 10/20/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate
{
    var mapView : MKMapView!
   
    override func loadView()
    {
        mapView = MKMapView()
        view = mapView
        mapView.delegate = self
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.showsScale = true
       
        let london = Capital(coordinate: CLLocationCoordinate2D(latitude: 51.50722, longitude: -0.1275), title: "london", subtitle: "home of olymics")
        let oslo = Capital(coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), title: "oslo", subtitle: "founded years ago")
        let paris = Capital(coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), title: "paris", subtitle: "eiffel twoer")
        let rome = Capital(coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), title: "rome", subtitle: "oldest country")
        let washington = Capital(coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.836667), title: "washington", subtitle: "home of olymics")
        
        mapView.addAnnotations([london,oslo,paris,rome,washington])
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(mapStyle) )
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: mapStyle)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /* make sure you applies this code to an annotation of type Capital */
        guard  annotation is Capital else {return nil}
        let identifier = "capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView  // -> MKAnnotationView
        
        if annotationView == nil
        {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.canShowCallout = true
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton
            annotationView?.pinTintColor = .black
            
        }else
        {
            
            annotationView?.annotation = annotation
            
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let title  = (view.annotation as? Capital)?.title else {return}
       
        let url = "https://en.wikipedia.org/wiki/\(title)"
        let detail = DetailViewController()
        detail.url = url
        navigationController?.pushViewController(detail, animated: true)
        
    }
    
    @objc func mapStyle()
    {
        let ac = UIAlertController(title: "map Type", message: "choose a map style", preferredStyle: .actionSheet)
  
        ac.addAction(UIAlertAction(title: "standard", style: .default,handler: selectMapStyle(_:)))
        ac.addAction(UIAlertAction(title: "satellite", style: .default,handler: selectMapStyle(_:)))
        ac.addAction(UIAlertAction(title: "hybrid", style: .default,handler: selectMapStyle(_:)))
        ac.addAction(UIAlertAction(title: "satelliteFlyover", style: .default,handler: selectMapStyle(_:)))
        ac.addAction(UIAlertAction(title: "hybridFlyover", style: .default,handler: selectMapStyle(_:)))
        ac.addAction(UIAlertAction(title: "mutedStandard", style: .default,handler: selectMapStyle(_:)))
        
        
        
        present(ac, animated: true)
    }
    
    func selectMapStyle(_ action : UIAlertAction?)
    {
        guard let type = action?.title else{return}
        switch type
        {
            case "standard":
                mapView.mapType = .standard
            case "satellite":
                mapView.mapType = .satellite
            case "hybrid":
                mapView.mapType = .hybrid
            case "satelliteFlyover":
                mapView.mapType = .satelliteFlyover
            case "hybridFlyover":
                mapView.mapType = .hybridFlyover
            case "mutedStandard":
                mapView.mapType = .mutedStandard
            case _ :
                return
        }
    }
}

