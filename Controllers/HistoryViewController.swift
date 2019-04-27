//
//  HistoryViewController.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit
import CoreData

 let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate
class HistoryViewController: BaseViewController {
    var allHistory = [HistoryData]()
    
    
    let lists = ["Live speed","live map", "Distance covered", "History"]
    let listsImages = [UIImage(named: "live speed")!,UIImage(named: "map")!,UIImage(named: "jogger")!,UIImage(named: "history")!]
  @IBOutlet var collectionView: UICollectionView!
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
        configure(collectionView: collectionView)
        collectionView.backgroundColor = .clear
     let DataRecieved =    FetchDataSaved(Enitity: Entity_History, Value1: "history")
        if DataRecieved.count > 0{
           
            guard   let tempMainDict = UnArchiveDataArray(widgetData: DataRecieved) as? [[String : Any]] else {
                return
            }
            for element in tempMainDict{
                print(element)
                guard let distance  = element["sDistance"] as? String else{
                break
                }
                guard let avgSpeed  = element["sAvgSpeed"] as? String else{
                    break
                }
                guard let end  = element["sEnd"] as? String else{
                    break
                }
                guard let start  = element["sStart"] as? String else{
                    break
                }
                guard let currentTimeStamp  = element["currentTimeStamp"] as? Double else{
                    break
                }
              
//                
               allHistory.append(HistoryData(end, start, distance, avgSpeed, currentTimeStamp))
            }
               self.allHistory = self.allHistory.sorted { $0.timestamp < $1.timestamp}
            
            
            print(tempMainDict)
        }
        // Do any additional setup after loading the view.
    }


}
extension HistoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    internal func configure(collectionView: UICollectionView) {
        //LUNCH
        
        collectionView.registerReusableCell(historyCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allHistory.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let History_Cell = historyCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
        let history = allHistory[indexPath.item]
        History_Cell.lblStart.text = history.sStart
        History_Cell.lblEnd.text = history.sEnd
        let lbl : [UILabel] = [  History_Cell.lblSpeed,  History_Cell.lblTotal]
        for label  in lbl{
               label.adjustsFontSizeToFitWidth = true
        }
        History_Cell.btnDistance.setTitle(history.distance + "M", for: .normal)
        History_Cell.btnSpeed.setTitle(history.avgSpeed + "Km/h", for: .normal)
      
        return History_Cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: collectionView.bounds.width, height: 120)
        } else {
            // Number of Items per Row
            let numberOfItemsInRow = 2
            
            // Current Row Number
            let rowNumber = indexPath.item/numberOfItemsInRow
            
            // Compressed With
            let compressedWidth = collectionView.bounds.width/3
            
            // Expanded Width
            let expandedWidth = (collectionView.bounds.width/3) * 2
            
            // Is Even Row
            let isEvenRow = rowNumber % 2 == 0
            
            // Is First Item in Row
            let isFirstItem = indexPath.item % numberOfItemsInRow != 0
            
            // Calculate Width
            var width: CGFloat = 0.0
            if isEvenRow {
                width = isFirstItem ? compressedWidth : expandedWidth
            } else {
                width = isFirstItem ? expandedWidth : compressedWidth
            }
            
            return CGSize(width: width, height: 100)
            
            
        }
        //
        //        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize{
        
        return CGSize(width: collectionView.bounds.width, height: 1)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    
}
struct HistoryData {

    let sEnd: String
    let sStart: String
    let distance: String
    let avgSpeed: String
     let timestamp: Double
    
    init(_ sEnd: String,_ sStart: String,
         _ distance: String,  _ avgSpeed: String,  _ timestamp: Double) {
      
        
            self.sEnd = sEnd
        self.sStart = sStart
        self.distance = distance
          self.avgSpeed = avgSpeed
           self.timestamp = timestamp
        
    }
    init?(dictionary : [String:Any]) {
        guard
            let sEnd : String = dictionary["sEnd"] as? String,
            let sStart : String = dictionary["sStart"] as? String,
            let distance : String = dictionary["distance"] as? String,
            let avgSpeed : String = dictionary["avgSpeed"] as? String,
            let timestamp : Double = dictionary["timestamp"] as? Double
            
            
            else { return nil }
        self.init(sEnd,sStart,distance,
                  avgSpeed,timestamp
        )
    }
    var PropertyListForAllContacts : [String:Any] {
        return   ["sEnd" : sEnd,"sStart" : sStart,
                  "distance" : distance,
                  "avgSpeed" : avgSpeed,"timestamp":timestamp
        ]
    }
    
}
