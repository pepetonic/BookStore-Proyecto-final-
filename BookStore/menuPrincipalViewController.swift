//
//  menuPrincipalViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit
import FirebaseAuth
import WebKit
import FirebaseFirestore

class menuPrincipalViewController: UIViewController {
    
    var libroManager = LibroManager()
    var libroRecibido: LibroModelo?
    let db = Firestore.firestore()
    var email: String?
    var saldo = 0.0
    var name = ""
    
    //listas
    var listaDeseos = [String]()
    var listaCompras = [String]()
    var bandera = false
    
    @IBOutlet weak var nombreLibroLabel: UILabel!
    @IBOutlet weak var resultadoLabel: UILabel!
    @IBOutlet weak var autorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var compraButton: UIButton!
    
    @IBOutlet weak var busquedaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Datos de la BD
        cargarUser()
        cargarListaDeseos()
        cargarBiblioteca()
        
        // Ocultar el boton de regresar
        navigationItem.hidesBackButton = true
        
        //Modificar botones
        favButton.layer.cornerRadius = 25.0
        compraButton.layer.cornerRadius = 25.0
        
        //Ocultar interfaz
        ocultarInterfaz()
        
        
        
        //Delegado de LibroManager
        libroManager.delegado = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Ocultar interfaz
        ocultarInterfaz()
        
        //Datos de la BD
        cargarUser()
        cargarListaDeseos()
        cargarBiblioteca()
    }
    
    func cargarUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            email = user.email
            db.collection("users").document(email!).getDocument{
                (document, error) in
                if let document = document, error == nil {
                    if let credito = document.get("saldo") as? Double {
                        self.saldo = credito
                        print("El saldo es: \(self.saldo)")
                    }
                    if let nombre = document.get("nombre") as? String{
                        self.name = nombre
                        print("El nombre es: \(self.name)")
                    }
                }
            }
        }
    }
    
    func cargarListaDeseos(){
        db.collection("listaDeseos").document(email!).getDocument{
            (document, error) in
            if let document = document, error == nil{
                if let libros = document.get("libros") as? [String]{
                    self.listaDeseos = libros
                }
            }
        }
    }
    
    func cargarBiblioteca(){
        db.collection("biblioteca").document(email!).getDocument {
            (document, error) in
            if let document = document, error == nil {
                if let libros = document.get("libros") as? [String]{
                    self.listaCompras = libros
                    print("Libros comprados: \(libros)")
                }
            }
        }
    }
    
    func ocultarInterfaz(){
        bandera = true
        nombreLibroLabel.text = ""
        resultadoLabel.text=""
        autorLabel.text = " "
        yearLabel.text = ""
        busquedaTextField.text = ""
        
        favButton.isHidden = bandera
        compraButton.isHidden = bandera
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
    
    
    @IBAction func agregarWishList(_ sender: Any) {
        listaDeseos.append(libroRecibido!.libroId)
        let data: [String: Any] = [
            "name":"Lista de deseos",
            "libros": listaDeseos
        ]
        
        db.collection("listaDeseos").document(email!).setData(data, merge: true){ error in
            if let error = error {
                print("Error en el documento: \(error)")
            }else {
                self.performSegue(withIdentifier: "toWishList", sender: self)
            }
            
        }
        
    }
    
    @IBAction func carritoCompras(_ sender: Any) {
        let alert = UIAlertController(title: "Comprar", message: "Seguro que desea realizar la compra", preferredStyle: .alert)
        
        let aceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            self.comprar()
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(aceptar)
        alert.addAction(cancelar)
        
        present(alert, animated: true, completion: nil)
    }
    
    func comprar(){
        if saldo > 149.99{
            saldo = saldo - 149.99
            listaCompras.append(libroRecibido!.libroId)
            let data: [String: Any] = [
                "name":"Lista de deseos",
                "libros": listaCompras
            ]
            
            db.collection("biblioteca").document(email!).setData(data, merge: true){ error in
                if let error = error {
                    print("Error en el documento: \(error)")
                }else {
                    self.db.collection("users").document(self.email!).setData([
                        "nombre" : self.name ,
                        "saldo" : self.saldo
                    ])
                    self.performSegue(withIdentifier: "toBiblioteca", sender: self)
                }
                
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "No cuenta con el saldo para realizar la compra", preferredStyle: .alert)
            let aceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            
            alert.addAction(aceptar)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension menuPrincipalViewController: LibroManagerDelegate {
    func actualizarLibro(libro: LibroModelo) {
        //print(libro.autores)
        libroRecibido = libro
        DispatchQueue.main.sync {
            //tablaLibros.reloadDat
            autorLabel.text = ""
            nombreLibroLabel.text = libro.nombreLibro
            resultadoLabel.text = "Resultado de la busqueda"
            yearLabel.text = "Fecha Publicación: \(libro.fechaPublicacion) Precio: $149.99"
            for escritor in libro.autores{
                autorLabel.text = "\(autorLabel.text ?? " "), \(escritor)"
            }
            print(listaDeseos)
            if listaDeseos.count > 0 {
                for id in listaDeseos {
                    if (libro.libroId == id){
                        favButton.isHidden = true
                        break
                    }else{
                        favButton.isHidden = false
                    }
                }
            }
            if listaCompras.count > 0 {
                for id in listaCompras {
                    if (libro.libroId == id){
                        compraButton.isHidden = true
                        break
                    }else{
                        compraButton.isHidden = false
                    }
                }
            }
        }
        
    }
    
}

