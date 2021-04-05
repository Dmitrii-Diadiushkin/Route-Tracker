//
//  MapViewController.swift
//  Route Tracker
//
//  Created by Dmitrii Diadiushkin on 05.04.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var mapView: GMSMapView!
    
    // MARK: - Declaration
    private var locationManager: CLLocationManager?
    private let initialCoordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    
    // MARK: - Lifetime functions

    override func viewDidLoad() {
        super.viewDidLoad()
        initialMapConfig()
        initialLocationManagerConfig()
    }
    // MARK: - IBActoins
    
    @IBAction func updateLocation(_ sender: UIBarButtonItem) {
        locationManager?.startUpdatingLocation()
    }
    @IBAction func currentLocation(_ sender: UIBarButtonItem) {
        locationManager?.requestLocation()
    }
    
    // MARK: - Functions
    private func initialMapConfig() {
        let camera = GMSCameraPosition(target: initialCoordinate, zoom: 15)
        mapView.camera = camera
        mapView.delegate = self
    }
    
    private func initialLocationManagerConfig(){
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    private func moveCamera(currentCoordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(target: currentCoordinate, zoom: 15)
        mapView.camera = camera
    }
    private func addMarker(coordinate: CLLocationCoordinate2D){
        let currentMarker = GMSMarker(position: coordinate)
        currentMarker.map = mapView
    }
    
    private func followMe(coordinate: CLLocationCoordinate2D){
        moveCamera(currentCoordinate: coordinate)
        addMarker(coordinate: coordinate)
    }
}

extension MapViewController: GMSMapViewDelegate{
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first?.coordinate {
            followMe(coordinate: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
