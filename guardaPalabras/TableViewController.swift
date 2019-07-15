//
//  TableViewController.swift
//  guardaPalabras
//
//  Created by Sandra Herrera on 15/07/19.
//  Copyright © 2019 Edison Effect. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    
    
    var manageObjects : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //a)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        //B
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
        
        //c
        
        do {
            manageObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No se puede recuperar los datos guardados. El error fue \(error) \(error.userInfo)")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manageObjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let managedObject = manageObjects[indexPath.row]
        cell.textLabel?.text = managedObject.value(forKey: "palabra") as? String

        return cell
    }
 
    @IBAction func addWords(_ sender: Any)
    {
        let alerta = UIAlertController(title: "Nueva palabra", message: "Introduce la nueva palabra", preferredStyle: .alert)
        let actionSave = UIAlertAction(title: "Agregar", style: .default) { (UIAlertAction) in
            let textField = alerta.textFields?.first!
            self.saveWord(palabra: textField!.text!)
            self.tableView.reloadData()
        }
        
        
        let cancelar = UIAlertAction(title: "cancelar", style: .cancel) { (UIAlertAction) in
        }
        alerta.addTextField { (UITextField) in
        }
        alerta.addAction(actionSave)
        alerta.addAction(cancelar)
        
        present(alerta, animated: true, completion: nil)
    }
    
    
    func saveWord(palabra : String)
    {
        // a) Para guardar o recuperar datos en CoreData necesitamos un objeto del tipo "managedObjectContext", podemos verlo como una libreta de apuntes o borradores donde trabajas con objetos del tipo ""NS managed Object
        //Se puede ver como que primero pone un nuevo objeto del tipo "managed object" dentro de tu "libreta de apuntes o borradores"(managedObjectContext) y una vez que tengas preparado tu objeto "NS managed object"  a como tu lo quieres ya le puedes decir a tu "libreta de apuntes" (managedObjectContext) que guarde los cambios en el "disco duro" de tu app
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        //b) entonces creamos un objeto del tipo nsmanagedObject por medio de la definición de clase "Entry" y con la ayuda de tu objeto del tipo "managedObjectContext"
        
        let entity = NSEntityDescription.entity(forEntityName: "Lista", in: managedContext)!
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        //c) Le añadimos valores a las propiedades de dicho objeto (en este caso solo tenemos la propiedad de "palabra")
        
        managedObject.setValue(palabra, forKeyPath: "palabra")
        
        //d) Y con la ayuda de nuestro objeto del tipo "managedObjectContext" (libreta de apuntes o borradores), guardamos los cambios
        
        
        do {
            try managedContext.save()
            manageObjects.append(managedObject)
        } catch let error as NSError {
            print("No se puede guardar, error: \(error) , \(error.userInfo)")
        }
    }
}
