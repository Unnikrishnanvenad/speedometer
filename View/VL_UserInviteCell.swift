//
//  CompassButton.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit
import Foundation

class VL_UserInviteCell: VL_UserInviteCollection {

    @IBOutlet var lblRow: UILabel!
    


    @IBOutlet var lblName: UILabel!
    /// Image View
    @IBOutlet var imageView: UIImageView!
 
    @IBOutlet var baseView: UIView!
    // MARK: - Factory Method
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> VL_UserInviteCell {
        guard let cell: VL_UserInviteCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue AppOfTheDayCell ***")
        }
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        baseView.layer.cornerRadius = 14.0
        baseView.clipsToBounds = true
//        baseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    
}
