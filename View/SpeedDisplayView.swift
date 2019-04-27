//
//  SpeedDisplayView.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit
protocol SpeedDisplayViewProtocol {
  
    func speedDisplayViewWarningButtonPressed(warningButton: WarningButton)
}

class SpeedDisplayView: UIView {
    
    // protocol object to talk with other classes that implement this protocol
    var speedDisplayViewProtocol: SpeedDisplayViewProtocol?
    
    // maximum speed of the speedometer, this can be altered to match your audience, e.g.: for sport cars set it to 300 or more, for trucks 120 would be enough (km/h)
    private let clockLimitSpeed = 100.0
    
    // a layer to show the current speed
    private var progressLayer: CAShapeLayer
    // a layer to show the maximum speed mark
    private var maxSpeedMarkerLayer: CAShapeLayer
    // layer to show the dashed circle layer
    private var dashedLayer: CAShapeLayer
    // button to be able to set the maximum speed
    private var warningButton: WarningButton
    // label to show the current speed
    private var speedLabel: UILabel
    // label to show the speed format (km/h)
    private var speedFormatlabel: UILabel
    private var speedconverter :Double = 1.0
    /**
     * Initializes the objects
     * @param: coder - NSCoder
     */
    required init?(coder aDecoder: NSCoder) {
        speedLabel = UILabel()
        speedFormatlabel = UILabel()
        warningButton = WarningButton()
        
        progressLayer = CAShapeLayer()
        maxSpeedMarkerLayer = CAShapeLayer()
        dashedLayer = CAShapeLayer()
        super.init(coder: aDecoder)
    }
    
    /**
     * Sets up progress layers and dashed layers to be able to show the current and maximum speed.
     */
    override func awakeFromNib() {
        backgroundColor = .clear
        let startAngle = Double.pi/2 + 0.31
        let endAngle = (Double.pi * 2 + Double.pi/2) - 0.34
        let centerPoint = CGPoint.init(x: frame.width/2, y: frame.height/2)
        progressLayer.path = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2, startAngle:CGFloat(startAngle), endAngle:CGFloat(endAngle), clockwise: true).cgPath
        progressLayer.backgroundColor = UIColor.clear.cgColor
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 10.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
        let dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = UIColor.white.cgColor
        dashedLayer.fillColor = nil
        dashedLayer.lineDashPattern = [2, 4]
        dashedLayer.lineJoin = convertToCAShapeLayerLineJoin("round")
        dashedLayer.lineWidth = 2.0
        dashedLayer.path = progressLayer.path
        layer.insertSublayer(dashedLayer, below: progressLayer)
        
        maxSpeedMarkerLayer.path = UIBezierPath(arcCenter:centerPoint, radius: frame.width/2 - 10.0 , startAngle:CGFloat(startAngle), endAngle:CGFloat(endAngle), clockwise: true).cgPath
        maxSpeedMarkerLayer.strokeColor = UIColor(white: 1.0, alpha: 0.8).cgColor
        maxSpeedMarkerLayer.fillColor = nil
        maxSpeedMarkerLayer.lineWidth = 2.0
        maxSpeedMarkerLayer.strokeEnd = progressLayer.strokeEnd
        
        
        
        addSpeedLabelToView()
        addSpeedFormatLabelToView()
        addWarningButton()
        
        
        
        
        super.awakeFromNib()
    }
    
    /**
     * Shows the maximum speed marker at the given maximum speed value with animation
     * @param: maxSpeed - maximum speed value
     */
    func showMaxSpeedMarkerAt(maxSpeed: Double) {
        layer.insertSublayer(maxSpeedMarkerLayer, below: progressLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(maxSpeed/clockLimitSpeed)
        animation.duration = 0.3
        maxSpeedMarkerLayer.add(animation, forKey: "strokeEnd")
        
        maxSpeedMarkerLayer.strokeEnd = CGFloat(maxSpeed/clockLimitSpeed)
          warningButton.setTitle(String(format: "MAX", arguments: [maxSpeed]), for: .normal)
//        warningButton.setTitle(String(format: "%.0f", arguments: [maxSpeed]), for: .normal)
        
        
    }
    
    /**
     * Hides the maximum speed marker layer
     */
    func hideMaxSpeedMarker() {
        maxSpeedMarkerLayer.removeFromSuperlayer()
    }
    
    /**
     * Sets the current speedof the user
     * @param: speed - current speed
     */
    func setCurrentSpeed(speed: Double) {
        
        let curSpeed =  speedconverter * speed
        speedLabel.text = String(format: "%.0f", arguments: [curSpeed])
        progressLayer.strokeEnd = CGFloat(curSpeed/clockLimitSpeed)
    }
    
    /**
     * Calls when the warning button pressed, tells the custom protocol to deliver the action
     */
    @objc func warningButtonPressed() {
        speedDisplayViewProtocol?.speedDisplayViewWarningButtonPressed(warningButton: warningButton)
    }
    
    /**
     * Creates and adds the warning button to the view
     */
    private func addWarningButton() {
        
        warningButton.setTitle("✧", for: .normal)
        warningButton.backgroundColor = .clear
        warningButton.setTitleColor(UIColor.white, for: .normal)
        warningButton.translatesAutoresizingMaskIntoConstraints = false
        warningButton.addTarget(self, action: #selector(SpeedDisplayView.warningButtonPressed), for: .touchUpInside)
        addSubview(warningButton)
        
        //  let customTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapUserCustomButton(_:)))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: warningButton, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottomMargin, relatedBy: .equal, toItem: warningButton, attribute: .bottomMargin, multiplier: 1.0, constant: -40.0))
        addConstraint(NSLayoutConstraint(item: warningButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0))
        addConstraint(NSLayoutConstraint(item: warningButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80.0))
    }
    
    /**
     * Creates and adds the speed label to the view
     */
    private func addSpeedLabelToView() {
        
        speedLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: 60.0))
        speedLabel.textColor = .white
        speedLabel.textAlignment = .center
        speedLabel.text = "0"
        speedLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 100.0)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedLabel)
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: speedLabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: speedLabel, attribute: .centerY, multiplier: 1.0, constant: 15.0))
    }
    
    /**
     * Creates and adds the speed format label to the view
     */
    private func addSpeedFormatLabelToView() {
        
        speedFormatlabel =  UILabel(frame: CGRect(x: 0.0, y: speedLabel.frame.maxY + 0.5 , width: frame.width, height: 30.0))
        //speedFormatlabel.layer.borderWidth = 0.5
        speedFormatlabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        speedFormatlabel.textAlignment = .center
        speedFormatlabel.text = "km/h"
        speedFormatlabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        speedFormatlabel.translatesAutoresizingMaskIntoConstraints = false
        
        //add gesture to label
        let speedFormatlabelTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.didTapUserCustomButton(_:)))
        speedFormatlabel.addGestureRecognizer(speedFormatlabelTapGesture)
        speedFormatlabel.isUserInteractionEnabled = true
        
        addSubview(speedFormatlabel)
        
        
        addConstraint(NSLayoutConstraint(item: speedLabel, attribute: .bottomMargin, relatedBy: .equal, toItem: speedFormatlabel, attribute: .topMargin, multiplier: 1.0, constant: -10.0))
        addConstraint(NSLayoutConstraint(item: speedLabel, attribute: .centerX, relatedBy: .equal, toItem: speedFormatlabel, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }
    
    
    @objc func didTapUserCustomButton(_ sender: UITapGestureRecognizer) {
        
        if(speedFormatlabel.text == "km/h"){
            speedFormatlabel.text = "mile/h"
            speedconverter = 0.621371
            
        } else {
            speedFormatlabel.text = "km/h"
            speedconverter = 1.0
        }
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineJoin(_ input: String) -> CAShapeLayerLineJoin {
	return CAShapeLayerLineJoin(rawValue: input)
}
