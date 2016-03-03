//
//  DetalleSugerenciaViewController.swift
//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 3/2/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class DetalleSugerenciaViewController: UIViewController {
    //<#properties and methods#>
    
    @IBOutlet weak var imgOpcion1: UIImageView!
    @IBOutlet weak var txtNombreE1: UILabel!
    @IBOutlet weak var txtSonido1: UILabel!
    
    @IBOutlet weak var imgOpcion2: UIImageView!
    @IBOutlet weak var txtNombreE2: UILabel!
    @IBOutlet weak var txtSonido2: UILabel!
    
    @IBOutlet weak var imgOpcion3: UIImageView!
    @IBOutlet weak var txtNombreE3: UILabel!
    @IBOutlet weak var txtSonido3: UILabel!
    
    var mayorEdificios = ["SD", "ML", "W", "NA"]
    var imagenesMayorEdificio = ["SD", "ML", "W", "NA"]
    var nivelesRuido = ["Muy bajo", "Muy bajo", "Muy bajo", "Bajo", "Bajo", "Bajo", "Medio", "Medio", "Alto", "Muy Alto"]
    
    
    var sugerencia : SugerenciaDia?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("llego detalle")
        print(sugerencia)
        
        if let i = sugerencia {
            
            print(i.mayor)
            var imageName = imagenesMayorEdificio[i.mayor]
            imgOpcion1.image = UIImage(named: imageName)!
            print(i.ruido)
            txtNombreE1.text = mayorEdificios[i.mayor]
            txtSonido1.text = "\(i.ruido) dB - \(nivelesRuido[Int(i.ruido/10)])"
            
            imageName = imagenesMayorEdificio[i.opcion1.0]
            imgOpcion2.image = UIImage(named: imageName)!
            txtNombreE2.text = mayorEdificios[i.opcion1.0]
            txtSonido2.text = "\(i.opcion1.2) dB - \(nivelesRuido[Int(i.opcion1.2/10)])"
            
            imageName = imagenesMayorEdificio[i.opcion2.0]
            imgOpcion3.image = UIImage(named: imageName)!
            txtNombreE3.text = mayorEdificios[i.opcion2.0]
            txtSonido3.text = "\(i.opcion2.2) dB - \(nivelesRuido[Int(i.opcion2.2/10)])"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}