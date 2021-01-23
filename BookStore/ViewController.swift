//
//  ViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registroButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 25.0
        registroButton.layer.cornerRadius = 25.0
        validarUsuarioLogueado()
    }


    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    
    @IBAction func registroUsuario(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegistro", sender: self)
    }
    
    func validarUsuarioLogueado (){
        if Auth.auth().currentUser != nil {
          // User is signed in.
            performSegue(withIdentifier: "userLogueado", sender: self)
        } else {
          // No user is signed in.
          print ("Favor de iniciar sesión")
        }
    }
}

