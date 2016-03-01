//
//  Registro.swift
//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 3/1/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class Registro: NSObject, NSCoding {
    let ruido: Int
    let dia: Int
    let hora: Int
    let mayor: Int
    let minor: Int

    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("registros")
    
    struct PropertyKey {
        static let ruidoKey = "ruido"
        static let diaKey = "dia"
        static let horaKey = "hora"
        static let mayorKey = "mayor"
        static let minorKey = "minor"
    }
    
    init(ruido: Int, dia: Int, hora: Int, mayor: Int, minor: Int) {
        
        self.ruido = ruido
        self.dia = dia
        self.hora = hora
        self.mayor =  mayor
        self.minor = minor
        super.init()
        
    }
    
    override
    var description: String {
        return "\(dia):\(hora):\(ruido):\(mayor):\(minor)"
    }
    
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(ruido, forKey: PropertyKey.ruidoKey)
        aCoder.encodeInteger(dia, forKey: PropertyKey.diaKey)
        aCoder.encodeInteger(hora, forKey: PropertyKey.horaKey)
        aCoder.encodeInteger(mayor, forKey: PropertyKey.mayorKey)
        aCoder.encodeInteger(minor, forKey: PropertyKey.minorKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let ruido = aDecoder.decodeIntegerForKey(PropertyKey.ruidoKey)
        let dia = aDecoder.decodeIntegerForKey(PropertyKey.diaKey)
        let hora = aDecoder.decodeIntegerForKey(PropertyKey.horaKey)
        let minor = aDecoder.decodeIntegerForKey(PropertyKey.minorKey)
        let mayor = aDecoder.decodeIntegerForKey(PropertyKey.mayorKey)
        
        self.init(ruido: ruido, dia: dia, hora: hora, mayor: mayor, minor: minor)
    }
}