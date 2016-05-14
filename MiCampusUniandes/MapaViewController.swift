//
//  MapaViewControlller.swift
//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 5/11/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class MapaViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            print("landscape mp")
            
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            print("Portrait mp")
            self.performSegueWithIdentifier("unwindToMain", sender: self)
        }
        
    }
    
    
}