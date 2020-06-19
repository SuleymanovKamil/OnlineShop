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

//Адрес доставки на главном экране обновляется через unwindSegue там же
class MapViewController: UIViewController {
    var adress = ""
    let locationManager = CLLocationManager()
    
    //MARK: - IBOutlers
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var okButtonOutlet: UIButton!
    
    override func viewDidLoad() {
//        navigationController?.setNavigationBarHidden(true, animated: false)
        self.mapView.isMyLocationEnabled = true
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
     
    
    //MARK: - IBAction
    @IBAction func exit(_ sender: UIButton) {
        if User.currentUser() == nil {
            performSegue(withIdentifier: "toPhoneVC", sender: self)
        } else {
    popTheView()

        }
    }
    @IBAction func okButtonPressed(_ sender: Any) {
        if User.currentUser() == nil {
                performSegue(withIdentifier: "toPhoneVC", sender: self)
            } else {
        popTheView()

            }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoneVC" {
            PhoneViewController.address = MainScreenCollectionView.mainAdress
            }
            
        }
   //Возвращаемся на предыдущее вью
   private func popTheView() {
       self.navigationController?.popViewController(animated: true)
   }
    
    //Кнопка центровки на локации пользователя
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {

        mapView.isMyLocationEnabled = true
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
                let lines = address.lines else {
                return
            }
    
            
            let street = lines.joined().split(separator: ",")
            
            self.adress = String(street[0] + street[1])
            self.addressLabel.text = self.adress
            DispatchQueue.main.async {
            MainScreenCollectionView.mainAdress = self.adress
            }
       
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

    //Стартовая локация
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


extension UINavigationController {
func popToViewController(ofClass: AnyClass, animated: Bool = true) {
  if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
    popToViewController(vc, animated: animated)
  }
}
}


