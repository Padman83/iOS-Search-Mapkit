//
//  ViewController.swift
//  iOS Search Mapkit
//
//  Created by Padman on 31/01/2020.
//  Copyright © 2020 Padman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    let initialLocation = CLLocation(latitude: 52.520008 ,longitude: 13.404954)
    let searchRadius: CLLocationDistance = 3000
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func searchOnValueChanged(_ sender: Any) {
        mapView.removeAnnotations(mapView.annotations)
        
        searchInMap()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchInMap()
        
        view.backgroundColor = .systemGray3
        
        mapView.delegate = self
        let coordinateRegion = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius * 2.0, longitudinalMeters: searchRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
    }

    
    func searchInMap() {
        // 1
       let request = MKLocalSearch.Request()
       request.naturalLanguageQuery = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: initialLocation.coordinate, span: span)
        
        // 3
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
                
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })
    }
    
    
 func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
     if let title = title {
         let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
         let annotation = MKPointAnnotation()
         annotation.coordinate = location
         annotation.title = title
         
         mapView.addAnnotation(annotation)
     }
 }
}

