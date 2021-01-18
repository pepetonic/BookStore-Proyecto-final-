//
//  menuPrincipalViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit
import FirebaseAuth

class menuPrincipalViewController: UIViewController {

    @IBOutlet weak var tablaLibros: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ocultar el boton de regresar
        navigationItem.hidesBackButton = true
        
    }
    

   
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Opciones", message: "Selecciona la opción deseada", preferredStyle: .alert)
        
        let actionMenuInfo = UIAlertAction(title: "Perfil", style: .default) { (_) in
            self.performSegue(withIdentifier: "toPerfil", sender: self)
        }
        
        let actionWhisList = UIAlertAction(title: "Whis List", style: .default) { (_) in
            self.performSegue(withIdentifier: "toWishList", sender: self)
        }
        
        let actionBiblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (_) in
            self.performSegue(withIdentifier: "toBiblioteca", sender: self)
        }
        
        let actionCancelar = UIAlertAction(title: "Cancelar", style: .cancel , handler: nil)
        
        
        alert.addAction(actionMenuInfo)
        alert.addAction(actionWhisList)
        alert.addAction(actionBiblioteca)
        alert.addAction(actionCancelar)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cerrarSesion(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Cerrar Sesión", message: "Desea cerrar su sesión", preferredStyle: .alert)
        
        let aceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            do {
              try Auth.auth().signOut()
                print("Se cerro la sesión")
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print ("Error al cerrar sesion", signOutError.localizedDescription)
            }
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(aceptar)
        alert.addAction(cancelar)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

/*
 
 func agegarContacto(_ sender: UIBarButtonItem) {
     let alert = UIAlertController(title: "Agregar Contacto", message: "Nuevo contacto", preferredStyle: .alert)
     
     alert.addTextField { (nombreAlert) in
         nombreAlert.placeholder = "Nombre"
     }
     alert.addTextField { (telefonoAlert) in
         telefonoAlert.placeholder = "Telefono"
     }
     alert.addTextField { (direccionAlert) in
         direccionAlert.placeholder = "Dircción"
     }

     let actionAceptar = UIAlertAction (title: "Aceptar", style: .default) { (_) in
         //Variables para guardar la info del nuevo contacto
         guard let nombreAlert = alert.textFields?.first?.text else { return }
         guard let telefonoAlert = alert.textFields?[1].text else { return }
         guard let direccionAlert = alert.textFields?.last?.text else { return }
         self.img = #imageLiteral(resourceName: "personsblue")
         
         if nombreAlert == "" || direccionAlert == "" {
             let alerta = UIAlertController(title: "Error", message: "Llena los campos", preferredStyle: .alert)
             let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
             alerta.addAction(aceptar)
             self.present(alerta,animated: true, completion: nil)
         }else{
             //Insert a la BD con menos código
             let nuevoContacto = Contacto(context: self.contexto)
             
             //Guardar img
             let imgData = self.img?.pngData()
             nuevoContacto.nombre = nombreAlert
             nuevoContacto.telefono = Int64(telefonoAlert) ?? 0
             nuevoContacto.direccion = direccionAlert
             nuevoContacto.img = imgData
             
             self.guardarContacto()
             
             self.contactos.append(nuevoContacto)
             self.TablaContactos.reloadData()
         }
     }
     
     let actionCancelar = UIAlertAction (title: "Cancelar", style: .default, handler: nil)
     
     alert.addAction(actionAceptar)
     alert.addAction(actionCancelar)
     
     present(alert,animated: true, completion:nil)
     
 }
 */
