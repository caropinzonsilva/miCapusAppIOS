//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 2/23/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class SugerenciaDia: NSObject {
    let edificio: String
    let ruido:Int
    let luz: Int
    let temperatura: Int
    let humedad: Int
    let hora: Int
    let mayor: Int
    let preferencia: Int
    let opcion1: (Int,Int,Int,Int)
    let opcion2: (Int,Int,Int,Int)
    let fecha:NSDate
    
    init(edificio: String, ruido: Int, luz: Int, temperatura: Int, humedad:Int, hora: Int, mayor: Int, preferencia: Int, opcion1: (Int,Int,Int,Int), opcion2: (Int,Int,Int,Int), fecha: NSDate) {
        self.edificio = edificio
        self.ruido = ruido
        self.luz = luz
        self.temperatura = temperatura
        self.humedad = humedad
        self.hora = hora
        self.mayor = mayor
        self.preferencia = preferencia
        self.opcion1 = opcion1
        self.opcion2 = opcion2
        self.fecha = fecha
        super.init()
    }
}
