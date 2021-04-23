//
//  ViewController.swift
//  Project16
//
//  Created by Nurbergen Yeleshov on 13.01.2021.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(mapStyle))
        
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func mapStyle() {
        let ac = UIAlertController(title: "Choose map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeMapStyle))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: changeMapStyle))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeMapStyle))
        ac.addAction(UIAlertAction(title: "HybridFlyover", style: .default, handler: changeMapStyle))
        ac.addAction(UIAlertAction(title: "MutedStandard", style: .default, handler: changeMapStyle))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func changeMapStyle(sender: UIAlertAction) {
        if sender.title == "Satellite" {
            mapView.mapType = .satellite
        } else if sender.title == "Standard" {
            mapView.mapType = .standard
        } else if sender.title == "Hybrid" {
            mapView.mapType = .hybrid
        } else if sender.title == "HybridFlyover" {
            mapView.mapType = .hybridFlyover
        } else if sender.title == "MutedStandard" {
            mapView.mapType = .mutedStandard
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is Capital else { return nil}
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            annotationView?.tintColor = UIColor.red
        } else {
            
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        
        let vc = WebViewController()
        vc.selectedCity = placeName
        
        navigationController?.pushViewController(vc, animated: true)
        
        
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
        
    }


}

