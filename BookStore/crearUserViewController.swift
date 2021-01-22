//
//  crearUserViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class crearUserViewController: UIViewController {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraTextField: UITextField!
    
    //instancia de firestore
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registroToFirebase(_ sender: UIButton) {
        if let nombre = nombreTextField.text, let email = correoTextField.text, let password = contraTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    if e.localizedDescription == "The password must be 6 characters long or more." {
                        self.alertaMSJ(descripcion: "Ingresa una contraseña segura de más de 5 caracteres")
                    }else if e.localizedDescription == "The email address is badly formatted." {
                        self.alertaMSJ(descripcion: "Ingresa un correo válido")
                    }else {
                        self.alertaMSJ(descripcion: "Checa que los datos sean correctos")
                    }
                }else{
                    //Registro exitoso en la bd
                    //Registrar datos de usuario en Cloud Firestore
                    self.db.collection("users").document(email).setData([
                        "nombre" : nombre,
                        "saldo": 0
                    ])
                    // crear lista de deseos vacía
                    let listaDeseos = [""]
                    let data: [String: Any] = [
                        "name":"Lista de deseos",
                        "libros": listaDeseos
                    ]
                    self.db.collection("listaDeseos").document(email).setData(data, merge: true){ error in
                        if let error = error {
                            print("Error en el documento: \(error)")
                        }
                    }
                    //crear biblioteca vacía
                    let biblioteca = [""]
                    let data1: [String: Any] = [
                        "name":"Lista de deseos",
                        "libros": biblioteca
                    ]
                    self.db.collection("biblioteca").document(email).setData(data1, merge: true){ error in
                        if let error = error {
                            print("Error en el documento: \(error)")
                        }else {
                            self.performSegue(withIdentifier: "toMenu", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    func alertaMSJ(descripcion: String){
        let alerta = UIAlertController (title: "Error!", message: descripcion, preferredStyle: .alert)
        let accion = UIAlertAction(title: "Aceptar", style: .default, handler: nil )
        alerta.addAction(accion)
        present(alerta, animated: true, completion: nil)
    }
    
}

/*
 
 
 
 
 */
