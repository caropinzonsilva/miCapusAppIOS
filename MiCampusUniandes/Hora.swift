//
//  Hora.swift
//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 2/23/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class Hora: NSObject, NSCoding {
    let edificio: String
    let ruido:Int
    let fecha:NSDate
    
    struct PropertyKey {
        static let fechaKey = "fecha"
        static let ruidoKey = "ruido"
        static let edificioKey = "edificio"
    }
    
    init(edificio: String, ruido: Int, fecha: NSDate) {
        
        self.edificio = edificio
        self.ruido = ruido
        self.fecha = fecha
        super.init()
        
    }
    
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fecha, forKey: PropertyKey.fechaKey)
        aCoder.encodeInteger(ruido, forKey: PropertyKey.ruidoKey)
        aCoder.encodeObject(edificio, forKey: PropertyKey.edificioKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //let fecha = aDecoder.decodeObjectForKey(PropertyKey.fechaKey) as! String
        let fecha = NSDate()
        let ruido = aDecoder.decodeIntegerForKey(PropertyKey.ruidoKey)
        let edificio = aDecoder.decodeObjectForKey(PropertyKey.edificioKey) as! String
        
        
        
        self.init(edificio: edificio, ruido: ruido, fecha: fecha)
    }
}
