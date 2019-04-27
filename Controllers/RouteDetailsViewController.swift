//
//  RouteDetailsViewController.swift
//  Speedometer
//
//  Created by IRISMAC on 25/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData
let Entity_History = "History"
class RouteDetailsViewController: BaseViewController {
    var run: Run!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "type") != nil {
            let value = UserDefaults.standard.value(forKey: "type")  as?  String
            if value == "cyclist"{
                setupNavBarWithUser(Type:"cyclist")
            }else{
                setupNavBarWithUser(Type:"jogger")
            }
        }
        // Do any additional setup after loading the view.
    }
   override func viewDidAppear(_ animated: Bool) {
         configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator("Please wait..")
        
//        self.effectView.removeFromSuperview()
        self.navigationController?.navigationBar.tintColor = .white
    }
    private func configureView() {
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let seconds = Int(run.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(run.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance covered:  \(formattedDistance)"
        dateLabel.text = formattedDate
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
        
            loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = run.locations,
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }

      private func polyLine() -> [MulticolorPolyline] {
      
        
        // 1
        let locations = run.locations?.array as! [Location]
        var coordinates: [(CLLocation, CLLocation)] = []
        var speeds: [Double] = []
        var minSpeed = Double.greatestFiniteMagnitude
        var maxSpeed = 0.0
        // result
        // 2
        for (first, second) in zip(locations, locations.dropFirst()) {
          
            
          let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
          let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            coordinates.append((start, end))
              let distanceInMeters = start.distance(from: end)
              let distanceRounded = Double(distanceInMeters).rounded(toPlaces: 2)
          //3
          let distance = end.distance(from: start)
           
            
          
          let time = second.timestamp!.timeIntervalSince(first.timestamp! as Date)
          let speed = time > 0 ? distance / time : 0
          speeds.append(speed)
          minSpeed = min(minSpeed, speed)
          maxSpeed = max(maxSpeed, speed)
            let avgSpeed = (minSpeed + maxSpeed) / 2
            let speedDigit = Double(avgSpeed).rounded(toPlaces: 2)
            
            if speedDigit > 0.0 && distanceRounded > 0.0{
                  activityIndicator("Please wait..")
                GetAddressFromStart(firstLatitude: first.latitude, firstLongitude: first.longitude, secondlLatitude:  second.latitude, secondLongitude: second.longitude, distance: distanceRounded, avgSpeed: speedDigit)
              
            }else{
                 self.effectView.removeFromSuperview()
            }
            
        }
//
        //4
        let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
        self.effectView.removeFromSuperview()
        //5
        var segments: [MulticolorPolyline] = []
        for ((start, end), speed) in zip(coordinates, speeds) {
          let coords = [start.coordinate, end.coordinate]
          let segment = MulticolorPolyline(coordinates: coords, count: 2)
          segment.color = segmentColor(speed: speed,
                                       midSpeed: midSpeed,
                                       slowestSpeed: minSpeed,
                                       fastestSpeed: maxSpeed)
          segments.append(segment)
        }
        return segments
      }

      private func loadMap() {
        guard
          let locations = run.locations,
          locations.count > 0,
          let region = mapRegion()
        else {
            let alert = UIAlertController(title: "Error",
                                          message: "Sorry, this run has no locations saved",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return
        }

        mapView.setRegion(region, animated: true)
        mapView.addOverlays(polyLine())
      }
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        let renderer = MKPolylineRenderer(overlay: overlay)
//
//        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
//
//        renderer.lineWidth = 5.0
//
//        return renderer
//    }
    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
        enum BaseColors {
            static let r_red: CGFloat = 1
            static let r_green: CGFloat = 20 / 255
            static let r_blue: CGFloat = 44 / 255
            
            static let y_red: CGFloat = 1
            static let y_green: CGFloat = 215 / 255
            static let y_blue: CGFloat = 0
            
            static let g_red: CGFloat = 0
            static let g_green: CGFloat = 146 / 255
            static let g_blue: CGFloat = 78 / 255
        }
        
        let red, green, blue: CGFloat
        
        if speed < midSpeed {
            let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
            red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
            green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
            blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
        } else {
            let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
            red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
            green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
            blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
extension RouteDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MulticolorPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = polyline.color
        renderer.lineWidth = 3
        return renderer
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
