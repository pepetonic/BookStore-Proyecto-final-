//
//  menuPrincipalViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit
import FirebaseAuth

class menuPrincipalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ocultar el boton de regresar
        navigationItem.hidesBackButton = true
        
    }
    

   
    
    @IBAction func cerrarSesion(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            print("Se cerro la sesión")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error al cerrar sesion", signOutError.localizedDescription)
        }
    }
    
}
