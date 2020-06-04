//
//  MapViewController.swift
//  OnlineShop
//
//  Created by Камиль on 01.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//


import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class MapViewController: UIViewController {
    

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        self.mapView.isMyLocationEnabled = true
        super.viewDidLoad()
        

        
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
 
    //Кнопка центровки на локации пользователя
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {

        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return false }

        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 17)
        mapView.animate(to: camera)

        return true

    }
    
    
    //Пишем адрес
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(),
                let lines = address.thoroughfare else {
                return
            }

            self.addressLabel.text = lines


            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        
    }
}



extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    func locationManager(_ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        let loc = location.coordinate
        mapView.camera = GMSCameraPosition(target: loc, zoom: 17, bearing: 0, viewingAngle: 0)
        
       
        locationManager.stopUpdatingLocation()
    }
    
}


