//
//  VerIngredientesViewController.swift
//  RecetasEfectivas
//
//

import UIKit

class ViewController: UITableViewController {
    
    var seleccion : Int = 0
    var edificios = ["ML","SD","W"]
    var sonidos = ["1","2","3"]
    var imagenes = ["ml","sd","w"]
    var horarios = [Hora]()
    
    override func viewDidLoad() {
        for j in 0...2{
            var hora : Hora = Hora (edificio: edificios[j], ruido: j, fecha: NSDate())
            //swiftBlogs[0].appendString(j.ingrediente.nombre as String)
            horarios.append(hora)
        }
        super.viewDidLoad()
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
        return horarios.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : HoraCell = tableView.dequeueReusableCellWithIdentifier("HorarioCell", forIndexPath: indexPath) as! HoraCell
        let row = indexPath.row
        cell.txtEdificio.text = horarios[row].edificio
        cell.txtSonido.text = String(horarios[row].ruido)
        
        let imageName = horarios[row].edificio
        var image : UIImage = UIImage(named: imageName)!
        cell.imgEdificio.image = image
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let d = horarios[row].fecha
        cell.txtHora.text = dateFormatter.stringFromDate(d)
        
        
        return cell
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
    
}
