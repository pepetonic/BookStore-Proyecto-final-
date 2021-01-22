//
//  PerfilViewController.swift
//  BookStore
//
//  Created by Mac5 on 17/01/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PerfilViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraTextField: UITextField!
    @IBOutlet weak var saldoTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 25.0
        //button.isHidden = true
        
        if Auth.auth().currentUser != nil {
            obtenerDatosUsuario()
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    

    func obtenerDatosUsuario(){
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            db.collection("users").document(email!).getDocument { (documenSnapshot, error) in
                if let document = documenSnapshot, error == nil {
                    if let nombre = document.get("nombre") as? String {
                        self.nombreTextField.text = nombre
                    }
                    if let saldo = document.get("saldo") as? Double {
                        self.saldoTextField.text = String(saldo)
                    }
                    self.correoTextField.text = email
                }
                
            }
        }
    }
    
    @IBAction func actualizarPerfil(_ sender: UIButton) {
        if let nombre = nombreTextField.text, let saldo = saldoTextField.text, let contra = contraTextField.text, let email = correoTextField.text  {
            if contra == "" || contra.count < 6 {
                db.collection("users").document(email).setData([
                    "nombre" : nombre ,
                    "saldo" : Double(saldo)
                ])
            } else {
                Auth.auth().currentUser?.updatePassword(to: contra) { (error) in
                    if error == nil{
                        self.db.collection("users").document(email).setData([
                            "nombre" : nombre,
                            "saldo" : Double(saldo)
                        ])
                    }else {
                        print(error!.localizedDescription)
                    }
                }
            }
            performSegue(withIdentifier: "returnMenu", sender: self)
        }
        
        
    }
    
}
