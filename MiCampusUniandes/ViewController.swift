//
//  VerIngredientesViewController.swift
//  RecetasEfectivas
//
//

import UIKit
import AVFoundation
import CoreLocation
import SystemConfiguration


class ViewController: UITableViewController, AVAudioRecorderDelegate, CLLocationManagerDelegate {
    
    var seleccion : Int = 0
    //var edificios = ["ML","SD","W"]
    var sonidos = ["1","2","3"]
    var sugerenciasDia = [SugerenciaDia]()
    var registros = [Registro]()
    var diasSemanaArray = ["D","L","M","I","J","V","S"]
    var diaSemana: Int = 0
    var hora: Int = 0
    //var mayorEdificios = ["SD - Piso 7", "SD - Piso 8", "SD - Piso 9", "SD - Piso 10", "ML - Sótano 1", "ML - Piso 1", "ML - Piso 2", "ML - Piso 3", "ML - Piso 4", "ML - Piso 5", "ML - Piso 6", "ML - Piso 7", "ML - Piso 8", "W Sótano 1", "W Piso 1", "W Piso 2", "W Piso 3", "W Piso 4", "W Piso 5", "W Piso 6"]
    var mayorEdificios = ["SD", "ML", "W", "NA"]
    var imagenesMayorEdificio = ["SD", "ML", "W", "NA"]
    var nivelesRuido = ["Muy bajo", "Muy bajo", "Muy bajo", "Bajo", "Bajo", "Bajo", "Medio", "Medio", "Alto", "Muy Alto"]
    
    //Grabar audio
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    //Bluetooth
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "A6CFB3CB-4BA1-4471-AE0E-4AE45A632798")!, identifier: "Estimotes")
    var listaBeacons = [CLBeacon]()
    
    override func viewDidLoad() {
        
        self.pedirSugerencias(4, hora: 13, ruido: 60, contador: 0)
        
        //Background de grabación de Audio
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            //print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                //print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        //Preguntar dia
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let myComponent = myCalendar?.components(.Weekday, fromDate: NSDate())
        let hour = myCalendar?.components(.Hour, fromDate: NSDate())
        diaSemana = (myComponent?.weekday)!
        hora = (hour?.hour)!
        
        
        var registrosCargados = cargarRegistros(diasSemanaArray[diaSemana])
        print(registrosCargados)
        if registrosCargados != nil {
            print("Registros cargados")
            registros = registrosCargados!
            /*registros = []
                for hora in 6...20 {
                    var ruido_r = 0
                    if (hora <= 14) {
                        ruido_r = 5*hora + 10
                    }
                    else {
                        ruido_r = 150 - 5*hora
                    }
                    let r_SD = Registro(ruido: ruido_r, dia: diaSemana, hora: hora, mayor: 0, minor: 0)
                    registros.append(r_SD)
                    if (hora <= 14) {
                        ruido_r = Int(5.5*Double(hora)) + 10
                    }
                    else {
                        ruido_r = 145 - Int(5.5*Double(hora))
                    }
                    let r_ML = Registro(ruido: ruido_r, dia: diaSemana, hora: hora, mayor: 1, minor: 0)
                    registros.append(r_ML)
                    if (hora <= 14) {
                        ruido_r = Int(4.4*Double(hora)) + 10
                    }
                    else {
                        ruido_r = 142 - Int(4.4*Double(hora))
                    }
                    let r_W = Registro(ruido: ruido_r, dia: diaSemana, hora: hora, mayor: 2, minor: 0)
                    registros.append(r_W)
                }*/
        }
        else {
            print("Registros no cargados")
            for dia in 0...6 {
                for hora in 6...22 {
                    var ruido_r = 0
                    if (hora <= 14) {
                        ruido_r = 5*hora + 10
                    }
                    else {
                        ruido_r = 150 - 5*hora
                    }
                    let r_SD = Registro(ruido: ruido_r, dia: dia, hora: hora, mayor: 0, minor: 0)
                    registros.append(r_SD)
                    if (hora <= 14) {
                        ruido_r = Int(5.5*Double(hora)) + 10
                    }
                    else {
                        ruido_r = 145 - Int(5.5*Double(hora))
                    }
                    let r_ML = Registro(ruido: ruido_r, dia: dia, hora: hora, mayor: 1, minor: 0)
                    registros.append(r_ML)
                    if (hora <= 14) {
                        ruido_r = Int(4.4*Double(hora)) + 10
                    }
                    else {
                        ruido_r = 142 - Int(4.4*Double(hora))
                    }
                    let r_W = Registro(ruido: ruido_r, dia: dia, hora: hora, mayor: 2, minor: 0)
                    registros.append(r_W)
                }
            }
            salvarRegistro(diasSemanaArray[diaSemana])
        }
        
        var sugerenciasProximasHoras: [(Int,Int,Int,Int)] = []
        
        var arregloOtrasOpciones1: [(Int,Int,Int,Int)] = []
        var arregloOtrasOpciones2: [(Int,Int,Int,Int)] = []
        
        let connected = isConnectedToNetwork()
        print("Is connected: " + String(connected))
        for i in 0...5 {
            let horaActual = hora + i
            print("hora: " + String(horaActual))
            let ruidoPreferencia = calcularPreferenciasHora(hora + i)
            print("ruidoPreferencia: " + String(ruidoPreferencia))
            if connected
            {
                self.pedirSugerencias(self.diaSemana, hora: self.hora + i, ruido: ruidoPreferencia*10, contador: 0)
            }
            else {
                
            }
            var sugerencia = cacularSugerenciaLugares(hora + i, ruido: ruidoPreferencia*10)
            //No encontro edificio con nivel de ruido de preferencia
            var encontrado = sugerencia[0].1 != 0
            var j = 0
            /*while !encontrado {
                j += 1
                sugerencia = cacularSugerenciaLugares(hora + i, ruido: (ruidoPreferencia + j)*10)
                encontrado = sugerencia[0].1 != 0
                if !encontrado {
                    sugerencia = cacularSugerenciaLugares(hora + i, ruido: (ruidoPreferencia - j)*10)
                    encontrado = sugerencia[0].1 != 0
                }
            }*/
            print("sugerencia: " + String(sugerencia))
            sugerenciasProximasHoras.append(sugerencia[0])
            arregloOtrasOpciones1.append(sugerencia[1])
            arregloOtrasOpciones2.append(sugerencia[2])
            
        }
        //print("sugerencias")
        //print(sugerenciasProximasHoras)
        
        
        //Inicializar las sugerencias del día
        var indiceSugerencias = 0
        for sugerencia in sugerenciasProximasHoras {
            if sugerencia.3 < 6 || sugerencia.3 > 23 {
                let sugerenciaDia: SugerenciaDia = SugerenciaDia(edificio: "Universidad cerrada", ruido: 0, hora: sugerencia.3, mayor: -1, preferencia: 0, opcion1: arregloOtrasOpciones1[indiceSugerencias], opcion2: arregloOtrasOpciones2[indiceSugerencias], fecha: NSDate())
                sugerenciasDia.append(sugerenciaDia)
            }
            //Universidad cerrada
            else {
                let sugerenciaDia: SugerenciaDia = SugerenciaDia(edificio: mayorEdificios[sugerencia.0], ruido: sugerencia.2, hora: sugerencia.3, mayor: sugerencia.0, preferencia: 0, opcion1: arregloOtrasOpciones1[indiceSugerencias], opcion2: arregloOtrasOpciones2[indiceSugerencias], fecha: NSDate())
                sugerenciasDia.append(sugerenciaDia)
            }
            indiceSugerencias += 1
            //let sugerenciaDia: SugerenciaDia = SugerenciaDia(edificio: mayorEdificios[sugerencia.0], ruido: sugerencia.2, fecha: NSDate())
            //sugerenciasDia.append(sugerenciaDia)
        }
        
        recordingSession = AVAudioSession.sharedInstance()
        
        //Pedir permisos para grabar audio
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        
                        self.tomarDatos()
                        
                    } else {
                        // failed to record!
                        print("no permiso")
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        super.viewDidLoad()
        
        //Pedir permisos bluetooth
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringForRegion(region)
        locationManager.requestStateForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sugerenciasDia.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : HoraCell = tableView.dequeueReusableCellWithIdentifier("HorarioCell", forIndexPath: indexPath) as! HoraCell
        let row = indexPath.row
        cell.txtEdificio.text = sugerenciasDia[row].edificio
        cell.txtSonido.text = "\(sugerenciasDia[row].ruido)dB - \(nivelesRuido[Int(sugerenciasDia[row].ruido / 10)])"
        
        var imageName = "sleep"
        if sugerenciasDia[row].mayor != -1 {
            imageName = imagenesMayorEdificio[sugerenciasDia[row].mayor]
        }
        var image : UIImage = UIImage(named: imageName)!
        cell.imgEdificio.image = image
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        cell.txtHora.text = "\(sugerenciasDia[row].hora)" + ":00"
        
        //cell.txtPreferencia = "\(sugerenciasDia[row].ruido)dB - \(nivelesRuido[Int(sugerenciasDia[row].ruido / 10)])"
        
        
        return cell
    }
    
    func loadRecordingUI() {
        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        recordButton.setTitle("Tap to Record", forState: .Normal)
        recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        recordButton.addTarget(self, action: "recordTapped", forControlEvents: .TouchUpInside)
        view.addSubview(recordButton)
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory() + "/recording.m4a"
            //.stringByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.meteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.record()
            
            //recordButton.setTitle("Tap to Stop", forState: .Normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            //recordButton.setTitle("Tap to Re-record", forState: .Normal)
        } else {
            //recordButton.setTitle("Tap to Record", forState: .Normal)
            // recording failed :(
        }
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func tomarDatos() {
        print("Toma de datos")
        //self.loadRecordingUI()
        self.startRecording()
        
        let delay = 10 * Double(NSEC_PER_SEC)//Delay de tiempo de grabacion
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            
            self.audioRecorder.updateMeters()
            
            var x = self.audioRecorder.averagePowerForChannel(0)
            if (x > 0) {
                x = 90
            }
            else {
                x = (x + 160)/160 * 90
            }
            print("dB registrados: " + String(x))
            print("Lista beacons encontrados")
            print(self.listaBeacons)
            
            self.finishRecording(success: true)
            
            var mayor = -1
            var minor = -1
            if self.listaBeacons.count > 0 {
                var beacon = self.listaBeacons[0] as CLBeacon
                if beacon.proximity.rawValue != 0 {
                    mayor = beacon.major.integerValue
                    minor = beacon.minor.integerValue
                }
            }
            let r = Registro(ruido: Int(x), dia: self.diaSemana, hora: self.hora, mayor: mayor, minor: minor)
            if mayor > -1 {
                //Solo mando registro si conosco el lugar de la persona, por le contrario sirve para calcular las preferencias del usuario
                self.mandarRegistro(self.diaSemana, hora: self.hora, ruido: Int(x), lugar: self.mayorEdificios[mayor])
            }
            
            self.registros.append(r)
            self.salvarRegistro(self.diasSemanaArray[self.diaSemana])
            print("Registros de hoy: ")
            print(self.registros)
            
            print(self.calcularPreferenciasHora(18))
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        listaBeacons = beacons
        //print(listaBeacons)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering region")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit region")
    }
    
    

    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VerIngrediente" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                var re = RecetasEfectivas.sharedInstance
                if let detalle = segue.destinationViewController as? DetalleIngrViewController{
                    detalle.ingrediente = re.ingredientes[indexPath.row]
                }
            }
        }
        
    }*/
    
    //Calculo de preferencias
    func calcularPreferenciasHora(hora: Int) -> Int {
        var cuentaRegistros = [0,0,0,0,0,0,0,0,0,0]
        for registro in registros {
            if registro.hora == hora {
                var indice = Int(registro.ruido / 10)
                cuentaRegistros[indice] += 1
            }
        }
        var max = -1
        var indiceMax = -1
        var indice = 0
        for cuenta in cuentaRegistros {
            if max < cuenta {
                max = cuenta
                indiceMax = indice
            }
            indice += 1
        }
        return indiceMax
    }
    
    //Calculo de sugerencia de lugares, retorna arreglo de Major de beacons
    func cacularSugerenciaLugares (hora: Int, ruido: Int) -> [(Int,Int,Int,Int)] {
        var lugaresOcurrencias: [(Int,Int,Int,Int)] = []
        for i in 0...self.mayorEdificios.count - 2 {
            lugaresOcurrencias.append((i,0,ruido,hora))
        }
        for registro in registros {
            if registro.hora == hora && Int(registro.ruido / 10)*10 == ruido && registro.mayor != self.mayorEdificios.count - 1 {
                if (registro.mayor != -1) {
                   lugaresOcurrencias[registro.mayor].1 += 1
                }
            }
        }
        lugaresOcurrencias = lugaresOcurrencias.sort{ $0.1 != $1.1 ? $0.1 > $1.1 : $0.0 < $1.0 }
        return lugaresOcurrencias
    }
    
    // MARK: NSCoding
    func salvarRegistro(dia: String) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(registros, toFile: Registro.ArchiveURL.path! + dia)
        if !isSuccessfulSave {
            print("Error guardando registros...")
        }
    }
    
    func cargarRegistros(dia: String) -> [Registro]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Registro.ArchiveURL.path! + dia) as? [Registro]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VerRecomendacion" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                var re = sugerenciasDia
                if let detalle = segue.destinationViewController as? DetalleSugerenciaViewController{
                    print("indexPath.row")
                    print(indexPath.row)
                    print(re[indexPath.row])
                    print("after")
                    detalle.sugerencia = re[indexPath.row]
                }
            }
        }
        
    }
    
    func mandarRegistro(dia: Int, hora: Int, ruido: Int, lugar: String) {
        // prepare json data
        
        let json = [ "dia":dia, "hora":hora, "ruido":ruido, "lugar":lugar ]
        do {
            var jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            //print("AVAudioSession is Active")
        
            // create post request
            let url = NSURL(string: "http://157.253.205.30/api/registroAdd")!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
        
                // insert json data to the request
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data,response,error in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                do {
                    if let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]{
                        print("Respuesta mandar registro: ")
                        print(responseJSON)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        
            task.resume()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func pedirSugerencias(dia: Int, hora: Int, ruido: Int, contador: Int) {
        // prepare json data
        
        let json = [ "dia":dia, "hora":hora, "ruido":ruido ]
        do {
            var jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            //print("AVAudioSession is Active")
            
            // create post request
            let url = NSURL(string: "http://157.253.205.30/api/darSugerencia")!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            // insert json data to the request
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data,response,error in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                do {
                    print("pedirSugerencias dia: " + String(dia) + ", hora: " + String(hora) + ", ruido: " + String(ruido))
                    print(contador)
                    if let responseJSON: NSArray = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSArray {
                        print("Respuesta pedir sugerencia: ")
                        print(responseJSON)
                        print(responseJSON.count)
                        if (responseJSON.count == 0) {
                            if (contador < 4) {
                                var nuevoRuido = 0
                                if (contador == 0) {
                                    nuevoRuido = ruido + 10
                                }
                                else if (contador == 1) {
                                    nuevoRuido = ruido - 20
                                }
                                else if (contador == 2) {
                                    nuevoRuido = ruido + 30
                                }
                                else {
                                    nuevoRuido = ruido - 40
                                }
                                let nuevoContador = contador + 1
                                self.pedirSugerencias(dia, hora: hora, ruido: nuevoRuido, contador: nuevoContador)
                            }
                            else {
                                print("No existen sugerencias")
                            }
                        }
                        
                    }                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
            task.resume()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
}
