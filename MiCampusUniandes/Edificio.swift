//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 2/23/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class Edificio: NSObject {
    let edificio: Int //0=ML, 1=SD
    let ruido:Int
    let luz: Int
    let temperatura: Int
    let humedad: Int
    
    init(edificio: Int, ruido: Int, luz: Int, temperatura: Int, humedad:Int) {
        self.edificio = edificio
        self.ruido = ruido
        self.luz = luz
        self.temperatura = temperatura
        self.humedad = humedad
        super.init()
    }
}
