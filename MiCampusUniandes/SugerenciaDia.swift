//  MiCampusUniandes
//
//  Created by Carolina Pinzon on 2/23/16.
//  Copyright © 2016 Carolina Pinzon. All rights reserved.
//

import UIKit

class SugerenciaDia: NSObject {
    let edificio: String
    let ruido:Int
    let fecha:NSDate
    
    init(edificio: String, ruido: Int, fecha: NSDate) {
        self.edificio = edificio
        self.ruido = ruido
        self.fecha = fecha
        super.init()
    }
}
