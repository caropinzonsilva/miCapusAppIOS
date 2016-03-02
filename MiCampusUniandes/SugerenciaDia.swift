//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 2/23/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class SugerenciaDia: NSObject {
    let edificio: String
    let ruido:Int
    let hora: Int
    let mayor: Int
    let preferencia: Int
    let fecha:NSDate
    
    init(edificio: String, ruido: Int, hora: Int, mayor: Int, preferencia: Int, fecha: NSDate) {
        self.edificio = edificio
        self.ruido = ruido
        self.hora = hora
        self.mayor = mayor
        self.preferencia = preferencia
        self.fecha = fecha
        super.init()
    }
}
