//
//  LaunchViewController.swift
//  Speedometer
//
//  Created by IRISMAC on 24/04/19.
//  Copyright © 2019 IRIS Medical Solutions. All rights reserved.
//

import UIKit

class LaunchViewController: BaseViewController {
   
    @IBOutlet var imgCyclist: UIImageView!
    @IBOutlet var imgJogger: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imgCyclist.image = imgCyclist.image!.withRenderingMode(.alwaysTemplate)
        imgCyclist.tintColor = UIColor.blue
//        imgCyclist.backgroundColor = UIColor.black
        
        imgJogger.image = imgJogger.image!.withRenderingMode(.alwaysTemplate)
        imgJogger.tintColor = UIColor.blue
//        imgJogger.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.  
    }
    

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnCyclistAction(_ sender: Any) {
        UserDefaults.standard.set("cyclist", forKey: "type")
         self.performSegue(withIdentifier: "Show", sender: self)
    }
    @IBAction func btnJoggerAction(_ sender: Any) {
          UserDefaults.standard.set("jogger", forKey: "type")
         self.performSegue(withIdentifier: "Show", sender: self)
    }
    
   
   
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Show"
        {
            
        }
    }
}
