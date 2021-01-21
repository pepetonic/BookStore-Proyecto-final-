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
    
    var libroManager = LibroManager()
    var libroBuscado: LibroModelo?

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
        
        //Delegado de LibroManager
        libroManager.delegado = self
        
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
            libroManager.fetchClima(libro: libro)
        }else{
            let alert = UIAlertController(title: "Error", message: "Rellene el campo de busqueda", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(aceptar)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension menuPrincipalViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objCelda = tablaLibros.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if libroBuscado == nil{
            objCelda.libroLabel.text = ""
            objCelda.autorLabel.text = ""
            objCelda.imageView?.image = #imageLiteral(resourceName: "libro")
            return objCelda
        } else {
            objCelda.libroLabel.text = libroBuscado?.nombreLibro
            objCelda.autorLabel.text = libroBuscado?.autores[0]
            return objCelda
        }
    }
    
    
}

extension menuPrincipalViewController: LibroManagerDelegate {
    func actualizarLibro(libro: LibroModelo) {
        //print(libro.autores)
        libroBuscado = libro
        print(libroBuscado)
        DispatchQueue.main.sync {
            tablaLibros.reloadData()
        }
        
    }
    
}

