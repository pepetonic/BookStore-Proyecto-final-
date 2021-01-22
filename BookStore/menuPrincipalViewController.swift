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
    var listaDeseos: [String]?
    var bandera: Bool?
    
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
    }
    
    func cargarUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            email = user.email
        }
    }
    
    func cargarListaDeseos(){
        db.collection("listaDeseos").document(email!).getDocument{
            (document, error) in
            if let document = document, error == nil{
                if let libros = document.get("libros") as? [String]{
                    self.listaDeseos = libros
                }else {
                    self.listaDeseos = []
                }
            }else{
                self.listaDeseos = []
            }
        }
    }
    
    func ocultarInterfaz(){
        bandera = true
        nombreLibroLabel.text = ""
        resultadoLabel.text=""
        autorLabel.text = " "
        yearLabel.text = ""
        
        favButton.isHidden = bandera!
        compraButton.isHidden = bandera!
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
        listaDeseos?.append(libroRecibido!.libroId)
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
        
    }
}

/*extension menuPrincipalViewController : UITableViewDelegate, UITableViewDataSource {
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
*/
extension menuPrincipalViewController: LibroManagerDelegate {
    func actualizarLibro(libro: LibroModelo) {
        //print(libro.autores)
        libroRecibido = libro
        DispatchQueue.main.sync {
            //tablaLibros.reloadDat
            autorLabel.text = ""
            nombreLibroLabel.text = libro.nombreLibro
            resultadoLabel.text = "Resultado de la busqueda"
            yearLabel.text = libro.fechaPublicacion
            for escritor in libro.autores{
                autorLabel.text = "\(autorLabel.text ?? " "), \(escritor)"
            }
            if listaDeseos != nil {
                for id in listaDeseos! {
                    if (libro.libroId == id){
                        bandera = true
                        break
                    }else{
                        bandera = false
                    }
                }
            }
            favButton.isHidden = bandera!
            compraButton.isHidden = false
        }
        
    }
    
}

