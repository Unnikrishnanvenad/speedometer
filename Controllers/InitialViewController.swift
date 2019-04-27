//
//  InitialViewController.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//
//
import UIKit

class InitialViewController: BaseViewController {
    let lists = ["Speedometer","Live Map", "Map + speedometer", "History"]
    let listsImages = [UIImage(named: "live speed")!,UIImage(named: "map")!,UIImage(named: "jogger")!,UIImage(named: "history")!]
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(collectionView: collectionView)
        collectionView.backgroundColor = .clear
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .white
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapSegue"
        {
          
        }
    }

}
extension InitialViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    internal func configure(collectionView: UICollectionView) {
        //LUNCH
        
        collectionView.registerReusableCell(VL_UserInviteCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lunch_Header_Cell = VL_UserInviteCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
     
        lunch_Header_Cell.lblName.textColor = .black
        lunch_Header_Cell.lblName.text = lists[indexPath.item]
        lunch_Header_Cell.lblName.adjustsFontSizeToFitWidth = true
        lunch_Header_Cell.imageView.image = listsImages[indexPath.item]

        return lunch_Header_Cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: collectionView.bounds.width, height: VL_UserInviteCollection.cellHeight)
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
        switch indexPath.item {
        case 0:
              self.performSegue(withIdentifier: "live", sender: self)
        case 1:
            self.performSegue(withIdentifier: "Map", sender: self)
        case 2:
            self.performSegue(withIdentifier: "SampleMap", sender: self)
    
        case 3:
            self.performSegue(withIdentifier: "history", sender: self)
        default:
            print( indexPath.item )
        }
    }
    
    
}
