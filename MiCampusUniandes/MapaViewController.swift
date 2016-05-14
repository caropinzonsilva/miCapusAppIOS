//
//  MapaViewControlller.swift
//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 5/11/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class MapaViewController: UIViewController {
    @IBOutlet weak var imgSonido1: UIImageView!
    @IBOutlet weak var imgHumedad1: UIImageView!
    @IBOutlet weak var imgTemperatura1: UIImageView!
    @IBOutlet weak var imgLuz1: UIImageView!
    
    @IBOutlet weak var imgSonido2: UIImageView!
    @IBOutlet weak var imgHumedad2: UIImageView!
    @IBOutlet weak var imgTemperatura2: UIImageView!
    @IBOutlet weak var imgLuz2: UIImageView!
    
    var edificios = [Edificio]()
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        let ml = edificios[0]
        if ml.humedad < 50 {
            let image : UIImage = UIImage(named: "h_bajo")!
            imgHumedad1.image = image
        }
        else if ml.humedad >= 40 && ml.humedad < 50 {
            let image : UIImage = UIImage(named: "h_media")!
            imgHumedad1.image = image
        }
        else {
            let image : UIImage = UIImage(named: "h_alta")!
            imgHumedad1.image = image
        }
        
        if ml.temperatura < 18 {
            let image : UIImage = UIImage(named: "t_baja")!
            imgTemperatura1.image = image
        }
        else if ml.temperatura >= 18 && ml.temperatura < 23 {
            let image : UIImage = UIImage(named: "t_media")!
            imgTemperatura1.image = image
        }
        else {
            let image : UIImage = UIImage(named: "t_alta")!
            imgTemperatura1.image = image
        }
        
        if ml.ruido < 60 {
            let image : UIImage = UIImage(named: "s_bajo")!
            imgSonido1.image = image
        }
        else if ml.ruido >= 60 && ml.ruido < 70 {
            let image : UIImage = UIImage(named: "s_medio")!
            imgSonido1.image = image
        }
        else {
            let image : UIImage = UIImage(named: "s_alto")!
            imgSonido1.image = image
        }
        
        if ml.luz < 7 {
            let image : UIImage = UIImage(named: "l_baja")!
            imgLuz1.image = image
        }
        else if ml.luz >= 7 && ml.luz < 25 {
            let image : UIImage = UIImage(named: "l_media")!
            imgLuz1.image = image
        }
        else {
            let image : UIImage = UIImage(named: "l_alta")!
            imgLuz1.image = image
        }
        
        let sd = edificios[1]
        if sd.humedad < 50 {
            let image : UIImage = UIImage(named: "h_bajo")!
            imgHumedad2.image = image
        }
        else if sd.humedad >= 50 && sd.humedad < 75 {
            let image : UIImage = UIImage(named: "h_media")!
            imgHumedad2.image = image
        }
        else {
            let image : UIImage = UIImage(named: "h_alta")!
            imgHumedad2.image = image
        }
        
        if sd.temperatura < 18 {
            let image : UIImage = UIImage(named: "t_baja")!
            imgTemperatura2.image = image
        }
        else if sd.temperatura >= 18 && sd.temperatura < 23 {
            let image : UIImage = UIImage(named: "t_media")!
            imgTemperatura2.image = image
        }
        else {
            let image : UIImage = UIImage(named: "t_alta")!
            imgTemperatura2.image = image
        }
        
        if sd.ruido < 60 {
            let image : UIImage = UIImage(named: "s_bajo")!
            imgSonido2.image = image
        }
        else if sd.ruido >= 60 && sd.ruido < 70 {
            let image : UIImage = UIImage(named: "s_medio")!
            imgSonido2.image = image
        }
        else {
            let image : UIImage = UIImage(named: "s_alto")!
            imgSonido2.image = image
        }
        
        if sd.luz < 7 {
            let image : UIImage = UIImage(named: "l_baja")!
            imgLuz2.image = image
        }
        else if sd.luz >= 7 && sd.luz < 25 {
            let image : UIImage = UIImage(named: "l_media")!
            imgLuz2.image = image
        }
        else {
            let image : UIImage = UIImage(named: "l_alta")!
            imgLuz2.image = image
        }
        
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