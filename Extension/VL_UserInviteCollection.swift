//
//  VL_UserInviteCollection.swift
//  VivaLunch
//
//  Created by IRISMAC on 17/11/18.
//  Copyright © 2018 IRIS Medical Solutions. All rights reserved.
//

import Foundation
import UIKit


internal class VL_UserInviteCollection: UICollectionViewCell {
    internal static  let screenSize: CGRect = UIScreen.main.bounds
    internal static let cellHeight: CGFloat = screenSize.height / 5
    internal static let lunchConfirmationcellHeight: CGFloat = 350
    
    private static let kInnerMargin: CGFloat = 10.0
    
    /// Core Motion Manager

    
    /// Long Press Gesture Recognizer
    private var longPressGestureRecognizer: UILongPressGestureRecognizer? = nil
    
    /// Is Pressed State
    private var isPressed: Bool = false
    
    /// Shadow View
    private weak var shadowView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        configureGestureRecognizer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: VL_UserInviteCollection.kInnerMargin,
                                              y: VL_UserInviteCollection.kInnerMargin,
                                              width: bounds.width - (2 * VL_UserInviteCollection.kInnerMargin),
                                              height: bounds.height - (2 * VL_UserInviteCollection.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        // Roll/Pitch Dynamic Shadow
        self.applyShadow()
        configureGestureRecognizer()
    }
    
    private func applyShadow() {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset  = CGSize(width: 1.0, height: 1.0)
            shadowView.layer.shadowOpacity = 0.35
            shadowView.layer.shadowOffset = CGSize.zero
            
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    
    // MARK: - Gesture Recognizer
    
    private func configureGestureRecognizer() {
        // Long Press Gesture Recognizer
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gestureRecognizer:)))
        longPressGestureRecognizer?.minimumPressDuration = 0.1
        addGestureRecognizer(longPressGestureRecognizer!)
    }
    
    @objc internal func handleLongPressGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            handleLongPressBegan()
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            handleLongPressEnded()
        }
    }
    
    private func handleLongPressBegan() {
        guard !isPressed else {
            return
        }
        
        isPressed = true
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    private func handleLongPressEnded() {
        guard isPressed else {
            return
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.2,
                       options: .beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform.identity
        }) { (finished) in
            self.isPressed = false
        }
    }
    
}
