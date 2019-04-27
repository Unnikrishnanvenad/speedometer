//
//  historyCell.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit
import Foundation

class historyCell: VL_UserInviteCollection {
    
    @IBOutlet var lblSpeed: UILabel!

    @IBOutlet var lblTotal: UILabel!
    
    
    @IBOutlet var btnSpeed: UIButton!
    
    @IBOutlet var lblEnd: UILabel!
    @IBOutlet var lblStart: UILabel!
 
    @IBOutlet var btnDistance: UIButton!

    /// Image View
   
    
    @IBOutlet var baseView: UIView!
    // MARK: - Factory Method
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> historyCell {
        guard let cell: historyCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue AppOfTheDayCell ***")
        }
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        baseView.layer.cornerRadius = 14.0
        baseView.clipsToBounds = true
        //        baseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    
}
