//
//  VerIngredientesViewController.swift
//  RecetasEfectivas
//
//

import UIKit
import AVFoundation
import CoreLocation

class ViewController: UITableViewController, AVAudioRecorderDelegate, CLLocationManagerDelegate {
    
    var seleccion : Int = 0
    var edificios = ["ML","SD","W"]
    var sonidos = ["1","2","3"]
    var sugerenciasDia = [SugerenciaDia]()
    var registros = [Registro]()
    var diasSemanaArray = ["D","L","M","I","J","V","S"]
    var diaSemana: Int = 0
    var hora: Int = 0
    var mayorEdificios = ["SD - Piso 7", "SD - Piso 8", "SD - Piso 9", "SD - Piso 10", "ML - Sótano 1", "ML - Piso 1", "ML - Piso 2", "ML - Piso 3", "ML - Piso 4", "ML - Piso 5", "ML - Piso 6", "ML - Piso 7", "ML - Piso 8", "W Sótano 1", "W Piso 1", "W Piso 2", "W Piso 3", "W Piso 4", "W Piso 5", "W Piso 6"]
    var imagenesMayorEdificio = ["SD", "SD", "SD", "SD", "ML", "ML", "ML", "ML", "ML", "ML", "ML", "ML", "ML", "W", "W", "LL", "W", "W", "W", "W"]
    
    //Grabar audio
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    //Bluetooth
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "92AB49BE-4127-42F4-B532-90FAF1E26491")!, identifier: "Estimotes")
    var listaBeacons = [CLBeacon]()
    
    override func viewDidLoad() {
        
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
        
        
        let registrosCargados = cargarRegistros(diasSemanaArray[diaSemana])
        print(registrosCargados)
        if registrosCargados != nil {
            print("registros cargados")
            registros = registrosCargados!
        }
        else {
            print("registros no cargados")
            salvarRegistro(diasSemanaArray[diaSemana])
        }
        
        var sugerenciasProximasHoras: [(Int,Int,Int,Int)] = []
        
        for i in 0...5 {
            print("hora:")
            print(hora + i)
            let ruidoPreferencia = calcularPreferenciasHora(hora + i)
            print("ruidoPreferencia")
            print(ruidoPreferencia)
            let sugerencia = cacularSugerenciaLugares(hora + i, ruido: ruidoPreferencia*10)
            print(sugerencia)
            sugerenciasProximasHoras.append(sugerencia[0])
            
        }
        print("sugerencias")
        print(sugerenciasProximasHoras)
        
        
        //Inicializar las sugerencias del día
        for sugerencia in sugerenciasProximasHoras {
            if sugerencia.3 < 6 || sugerencia.3 > 19 {
                let sugerenciaDia: SugerenciaDia = SugerenciaDia(edificio: "Universidad cerrada", ruido: 0, hora: sugerencia.3, mayor: -1, fecha: NSDate())
                sugerenciasDia.append(sugerenciaDia)
            }
            //Universidad cerrada
            else {
                let sugerenciaDia: SugerenciaDia = SugerenciaDia(edificio: mayorEdificios[sugerencia.0], ruido: sugerencia.2, hora: sugerencia.3, mayor: sugerencia.0, fecha: NSDate())
                sugerenciasDia.append(sugerenciaDia)
            }
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
        
        print(UIApplication.sharedApplication().backgroundRefreshStatus)
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
        cell.txtSonido.text = String(sugerenciasDia[row].ruido)
        
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
            print("audioRec")
            print(audioRecorder)
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
        print("antes")
        //self.loadRecordingUI()
        self.startRecording()
        
        print("inside while")
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
            print(x)
            print(self.listaBeacons)
            
            self.finishRecording(success: true)
            print("despues")
            
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
            self.registros.append(r)
            
            self.salvarRegistro(self.diasSemanaArray[self.diaSemana])
            
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
        for i in 0...20 {
            lugaresOcurrencias.append((i,0,ruido,hora))
        }
        for registro in registros {
            if registro.hora == hora && Int(registro.ruido / 10)*10 == ruido {
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
    
}
