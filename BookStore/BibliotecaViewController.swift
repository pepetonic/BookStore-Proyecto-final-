//
//  BibliotecaViewController.swift
//  BookStore
//
//  Created by Mac5 on 17/01/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class BibliotecaViewController: UIViewController {
    
    let db = Firestore.firestore()
    var email: String?
    var listaBiblioteca = [String]()
    var libros = [LibroModelo]()
    
    var libroManager = LibroManager()
    var libroRecibido: LibroModelo?

    @IBOutlet weak var tablaBiblioteca: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // celda personalizada
        tablaBiblioteca.dataSource = self
        tablaBiblioteca.delegate = self
        tablaBiblioteca.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //Delegao de LibroManager
        libroManager.delegado = self
        
        //Datos usuario
        cargarUser()
        
        //cargar biblioteca
        cargarBiblioteca()
    }
    
    func cargarUser(){
            let user = Auth.auth().currentUser
            if let user = user {
                email = user.email
            }
    }
    
    func cargarBiblioteca(){
        db.collection("biblioteca").document(email!).getDocument{
            (document, error) in
            if let document = document, error == nil{
                if let libros = document.get("libros") as? [String]{
                    self.listaBiblioteca = libros
                    self.cargarLibros()
                }
            }
        }
    }
    
    func cargarLibros() {
        print("Lista de deseos: \(listaBiblioteca)")
        for id in listaBiblioteca {
            libroManager.fetchClima(libro: id)
        }
    }
    
    
}

extension BibliotecaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objCelda = tablaBiblioteca.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
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
}

extension BibliotecaViewController: LibroManagerDelegate {
    func actualizarLibro(libro: LibroModelo) {
        print("libro")
        libros.append(libro)
        DispatchQueue.main.sync {
            tablaBiblioteca.reloadData()
        }
    }
}
