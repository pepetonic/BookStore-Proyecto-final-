//
//  menuPrincipalViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit
import FirebaseAuth
import WebKit

class menuPrincipalViewController: UIViewController {
    
    let libroManager = LibroManager()

    @IBOutlet weak var tablaLibros: UITableView!
    @IBOutlet weak var busquedaTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ocultar el boton de regresar
        navigationItem.hidesBackButton = true
        //Celda personalizada
        tablaLibros.dataSource = self
        tablaLibros.delegate = self
        tablaLibros.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
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
    
    
    @IBAction func buscarLibros(_ sender: UIButton) {
        if let libro = busquedaTextField.text, libro != "" {
            //buscarLibroApi(busqueda: libro)
            libroManager.fetchClima(libro: libro)
        }else{
            let alert = UIAlertController(title: "Error", message: "Rellene el campo de busqueda", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(aceptar)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /*func buscarLibroApi (busqueda: String){
        let urlAPI = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(busqueda.replacingOccurrences(of: " ", with: "%20"))")
        let peticion = URLRequest(url: urlAPI!)
        let tarea = URLSession.shared.dataTask(with: peticion){ datos, respuesta, error in
            if error != nil {
                print(error!)
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    //print (json)
                    
                    let items = json ["totalItems"] as! Int
                    
                    print(items)
                    
                    let subjson  = json as! [String: Any]
                    
                    let idLibro = subjson ["id"] as! String
                    print(idLibro)
                                        
                    
                    
                }catch{
                    print("Error al procesar el JSON: \(error.localizedDescription)")
                }
            }
        }
        tarea.resume()
    }*/

    
}

extension menuPrincipalViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        /*let celda = tablaLibros.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = contactos[indexPath.row].nombre
        celda.detailTextLabel?.text = String(contactos[indexPath.row].telefono ?? 0)
        return celda*/
        
        let objCelda = tablaLibros.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        objCelda.libroLabel.text = "Libro"
        objCelda.autorLabel.text = "Autor"
        objCelda.imageView?.image = #imageLiteral(resourceName: "libro")
        return objCelda
         
    }
    
    
}

