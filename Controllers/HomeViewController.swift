//
//  HomeViewController.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import MapKit
import CoreData


class HomeViewController: BaseViewController , LocationHandlerProtocol,SpeedDisplayViewProtocol{
    
    let locationHandler = LocationHandler()
    var maximumSpeed: Double?
    
    
    
    @IBOutlet var speedDisplayView: SpeedDisplayView!
    @IBOutlet var maxSpeedLabel: UILabel!
    
    //MARK:- View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxSpeedLabel.text = ""
        maxSpeedLabel.textColor = UIColor(white: 1.0, alpha: 0.4)
        speedDisplayView.speedDisplayViewProtocol = self
        locationmgr = CLLocationManager()
        locationmgr.requestWhenInUseAuthorization()
        self.speedDisplayView.showMaxSpeedMarkerAt(maxSpeed: 100)
        self.maximumSpeed = 100
        self.maxSpeedLabel.text = String(format: "Max speed 100 km/h", 100)
        if UserDefaults.standard.value(forKey: "type") != nil {
            let value = UserDefaults.standard.value(forKey: "type")  as?  String
            if value == "cyclist"{
                setupNavBarWithUser(Type:"cyclist")
            }else{
                setupNavBarWithUser(Type:"jogger")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationHandler.locationHandlerProtocol = self
    }
    //MARK:- Gradients
    
    
    
    //MARK:- Location methods
    func locationHandlerDidUpdateHeading(newHeading: CLHeading) {
        
    }
    
    /**
     * Displays the received speed value and checks if it is more than the maximum speed.
     * @param: speed - current speed
     * @param: location - current location
     */
    func locationHandlerDidUpdateLocationWithSpeed(speed: Double, location: CLLocation) {
        if speed > 0
        {
            let formattedSpeed: Double = speed
            speedDisplayView.setCurrentSpeed(speed: formattedSpeed)
            checkCurrentSpeedOverMaximumSpeed(currentSpeed: formattedSpeed)
        }
    }
    func checkCurrentSpeedOverMaximumSpeed(currentSpeed: Double) {
        if (currentSpeed >= maximumSpeed! && maximumSpeed != nil)
        {
            gradientLayer.colors = CAGradientLayer.gradientColors(warning: true)
        }
        else
        {
            gradientLayer.colors = CAGradientLayer.gradientColors(warning: false)
            
        }
    }
    //MARK:- Location methods
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapSegue"
        {
            let mapViewController = segue.destination as! MapViewController
            mapViewController.locationSpeed = (locationHandler.currentUserLocation?.speed)!
            
            locationHandler.locationHandlerProtocol = mapViewController
            
            mapViewController.dismissButton.setCurrentSpeed(speed: (locationHandler.currentUserLocation?.speed)!)
        }
    }
    func speedDisplayViewWarningButtonPressed(warningButton: WarningButton) {
        //    if maximumSpeed != nil
        //   {
        //      maximumSpeed = nil
        //       warningButton.setTitle("!", for: .normal)
        //       speedDisplayView.hideMaxSpeedMarker()
        //       maxSpeedLabel.text = ""
        //   }
        // else
        // {
        let alertView = UIAlertController(title: "Set maximum speed", message: "Set up a maximum speed to be alerted when your current speed passes it.", preferredStyle: .alert)
        alertView.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Max speed limit"
            textField.keyboardType = .numberPad
            textField.becomeFirstResponder()
        }
        alertView.addAction(UIAlertAction(title: "Set", style: .default, handler: { (alertAction) -> Void in
            if let textField = alertView.textFields?.first
            {
                if let text = textField.text {
                    let maxSpeed: Double = (text as NSString).doubleValue
                    if maxSpeed > 0
                    {
                        self.speedDisplayView.showMaxSpeedMarkerAt(maxSpeed: maxSpeed)
                        self.maximumSpeed = maxSpeed
                        self.maxSpeedLabel.text = String(format: "Max speed %.0f km/h", maxSpeed)
                        
                        
                        //   self.present(alertController, animated: true, completion: isBeingDismissed)
                    }
                }
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertView, animated: true, completion: nil)
        //  }
    }
    
    
    
}
class BaseViewController: UIViewController {
    var City = ""
    var ZipCode = ""
    var Street = ""
    var Country = ""
    var State = ""
    var AddressLine1 = ""
    var GeoCode_Lati = ""
    var GeoCode_Long = ""
    var workSpaceName = ""
    var radius = ""
    var WorklocationID = 0
    
    var addressTofind = ""
    var locationmgr : CLLocationManager!
    var gradientLayer = CAGradientLayer()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientBackground()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    func GetAddressFromStart(firstLatitude: CLLocationDegrees, firstLongitude: CLLocationDegrees,secondlLatitude: CLLocationDegrees, secondLongitude: CLLocationDegrees,distance:Double,avgSpeed:Double) {
        
       
        var subThroughfare = ""
        var throughfare = ""
       
     
        var formattedAdress = ""
    
        var Addrlocality = ""
        var subLocality = ""
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = firstLatitude
        center.longitude = firstLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let Ourplace = placemarks! as [CLPlacemark]
                if Ourplace.count > 0 {
                    let LocationRecieved = placemarks![0]
                    print(LocationRecieved)
                    if LocationRecieved.subThoroughfare != nil {
                        subThroughfare = (LocationRecieved.subThoroughfare)!
                        formattedAdress = subThroughfare
                    }
                    if LocationRecieved.thoroughfare != nil {
                        throughfare = (LocationRecieved.thoroughfare)!
                        formattedAdress = formattedAdress + " " + throughfare
                        
                    }
                    if LocationRecieved.subLocality != nil {
                        subLocality = (LocationRecieved.subLocality)!
                        formattedAdress = formattedAdress + ", " + subLocality
                    }
                    if LocationRecieved.locality != nil {
                        Addrlocality = (LocationRecieved.locality)!
                        formattedAdress = formattedAdress + ", " + Addrlocality
                    }
            
                  self.AddressLine1 = formattedAdress
                    if self.AddressLine1 != ""{
                        self.GetAddressFromEnd(SecondLatitude: secondlLatitude, SecondLongitude: secondLongitude, sDistance: distance, sAvgSpeed: avgSpeed, sStart: self.AddressLine1)
                        
                    }
                    
                }
        })
        
        
    }
    func saveData(start: String, end: String,Distance:String,AvgSpeed:String){
        var tempDict = [String:Any]()
        let currentTimeStamp : NSNumber = (Date().timeIntervalSince1970 as AnyObject as! NSNumber)
       
        guard let sStart = start as? String, let sEnd = end as? String,  let sDistance = Distance as? String,  let sAvgSpeed = AvgSpeed as? String  else {
            return
        }
        tempDict["sStart"] = start
        tempDict["sEnd"] = end
        tempDict["sDistance"] = Distance
        tempDict["sAvgSpeed"] = AvgSpeed
        tempDict["currentTimeStamp"] = currentTimeStamp
         print(tempDict)
        let DataRecieved =  self.FetchDataSaved(Enitity: Entity_History, Value1: "history")
        if DataRecieved.count > 0{
            if  var tempMainDict = self.UnArchiveDataArray(widgetData: DataRecieved) as? [[String : Any]]{
                if tempMainDict.count>0{
                    tempMainDict.append(tempDict)
                    self.deleteAllData(entity: Entity_History)
                    let DataForSave = self.archiveDataArray(widgetDataArray: tempMainDict)
                    self.SaveDetals(AllData: DataForSave, Enitity: Entity_History, Value1: "history")
                }
                
                
            }
        }else{
            self.deleteAllData(entity: Entity_History)
            let DataForSave = self.archiveDataArray(widgetDataArray: [tempDict])
            self.SaveDetals(AllData: DataForSave, Enitity: Entity_History, Value1: "history")
        }
         self.effectView.removeFromSuperview()
        
    }
    func GetAddressFromEnd(SecondLatitude: CLLocationDegrees,SecondLongitude: CLLocationDegrees,sDistance:Double,sAvgSpeed:Double,sStart:String) {

        var subThroughfare = ""
        var throughfare = ""
     
        var formattedAdress = ""
      
        var Addrlocality = ""
        var subLocality = ""
      
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = SecondLatitude
        center.longitude = SecondLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let Ourplace = placemarks! as [CLPlacemark]
                if Ourplace.count > 0 {
                    let LocationRecieved = placemarks![0]
                    print(LocationRecieved)
                    if LocationRecieved.subThoroughfare != nil {
                        subThroughfare = (LocationRecieved.subThoroughfare)!
                        formattedAdress = subThroughfare
                    }
                    if LocationRecieved.thoroughfare != nil {
                        throughfare = (LocationRecieved.thoroughfare)!
                        formattedAdress = formattedAdress + " " + throughfare
                        
                    }
                    if LocationRecieved.subLocality != nil {
                        subLocality = (LocationRecieved.subLocality)!
                        formattedAdress = formattedAdress + ", " + subLocality
                    }
                    if LocationRecieved.locality != nil {
                        Addrlocality = (LocationRecieved.locality)!
                        formattedAdress = formattedAdress + ", " + Addrlocality
                    }
                    
                    self.AddressLine1 = formattedAdress
                    
                    if self.AddressLine1 != ""{
                        let sDistance:String = String(format:"%.2f", sDistance)
                        let sAvgSpeed:String = String(format:"%.2f", sAvgSpeed)
                        self.saveData(start: sStart, end: self.AddressLine1, Distance: sDistance, AvgSpeed: sAvgSpeed)
                        
                    }
                    
                    
                }
        })
        
    }
    func UnArchiveDataArray(widgetData : Data) ->  [[String:Any]] {
        do {
            guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(widgetData) as? [[String:Any]] else {
                fatalError("loadWidgetDataArray - Can't get Array")
            }
            return array
        } catch {
            fatalError("loadWidgetDataArray - Can't encode data: \(error)")
        }
        
    }
    func deleteAllData(entity: String)
    {
        
        let managedContext = APPDELEGATE!.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    @objc func SaveDetals(AllData:Data,Enitity:String,Value1:String){
        let context: NSManagedObjectContext = APPDELEGATE!.managedObjectContext
        do {
            let FilterData = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: Enitity, in: context)!, insertInto:context)
            FilterData.setValue(AllData, forKey: Value1)
            do {
                
                try context.save()
                
            } catch let error as NSError {
                //                print(error)
            }
        }catch let error as NSError {
            print(error)
        }
    }
    func archiveDataArray(widgetDataArray : [[String:Any]]) -> Data {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: widgetDataArray, requiringSecureCoding: false)
            
            return data
        } catch {
            fatalError("Can't encode data: \(error)")
        }
        
    }
    @objc func FetchDataSaved(Enitity:String,Value1:String)->Data{
        var Detals = Data()
        var fetchResults = [NSManagedObject]()
        let fetchRecentSearchICD: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Enitity)
        //        fetchRecentSearchICD.predicate = NSPredicate(format: "providerID = %@", String(PROVIDER_ID) )
        do {
            fetchResults = try APPDELEGATE!.managedObjectContext.fetch(fetchRecentSearchICD) as! [NSManagedObject]
            if fetchResults.count > 0{
                for result in  fetchResults.reversed() as [NSManagedObject]{
                    let Dict = result.value(forKey: Value1)
                    Detals  = Dict as! Data
                }
            }
        }
        catch {
        }
        return Detals
    }
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    func addGradientBackground() {
        gradientLayer = CAGradientLayer.normalGradientLayer(frame: view.frame)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    func setupNavBarWithUser(Type:String) {
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        if Type == "jogger"{
            profileImageView.image = UIImage(named: "jogger")!
        }else{
            profileImageView.image = UIImage(named: "cyclist")!
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = Type
        nameLabel.textColor = .white
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        //        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
}
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
