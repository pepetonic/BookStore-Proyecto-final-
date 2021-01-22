//
//  WhisListViewController.swift
//  BookStore
//
//  Created by Mac5 on 17/01/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class WhisListViewController: UIViewController {
    
    let db = Firestore.firestore()
    var email: String?
    var listaDeseos =  [String]()
    var libros = [LibroModelo]()
    //var libros: [LibroModelo]?
    
    var libroManager = LibroManager()
    var libroRecibido: LibroModelo?
    
    @IBOutlet weak var tablaLibros: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Celda personalizada
        tablaLibros.dataSource = self
        tablaLibros.delegate = self
        tablaLibros.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //Delegado de LibroManager
        libroManager.delegado = self
        
        //Datos usuario
        cargarUser()
        
        //Cargar listda de deseos
        cargarListaDeseos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tablaLibros.reloadData()
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
                    self.cargarLibros()
                }
            }
        }
    }
    
    func cargarLibros() {
        print("Lista de deseos: \(listaDeseos)")
        for listaDeseo in listaDeseos {
            libroManager.fetchClima(libro: listaDeseo)
        }
    }
    
   
    

}


extension WhisListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libros.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objCelda = tablaLibros.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        objCelda.libroLabel.text = libros[indexPath.row].nombreLibro
        var escritor = " "
        
        let autores = libros[indexPath.row].autores
        for autor in autores{
            escritor = "\(escritor) \(autor)."
        }
        objCelda.autorLabel.text = escritor
        objCelda.imageView?.image = #imageLiteral(resourceName: "libro")
        return objCelda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            var libroEliminado = libros[indexPath.row]
            let idEliminado = libroEliminado.libroId
            libros.remove(at: indexPath.row)
            var i = 0
            for lista in listaDeseos{
                if lista == idEliminado{
                    listaDeseos.remove(at: i)
                }
                i += 1
            }
            //Actualizo los datos de firestore y se elminia el id seleccionado
            let data: [String: Any] = [
                "name":"Lista de deseos",
                "libros": listaDeseos
            ]
            
            db.collection("listaDeseos").document(email!).setData(data, merge: true){ error in
                if let error = error {
                    print("Error en el documento: \(error)")
                }else {
                    self.tablaLibros.reloadData()
                }
                
            }
        }
    }
}

extension WhisListViewController: LibroManagerDelegate {
    func actualizarLibro(libro: LibroModelo) {
        print(libro)
        libros.append(libro)
        DispatchQueue.main.sync {
            tablaLibros.reloadData()
        }
    }
    
    
}
