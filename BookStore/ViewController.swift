//
//  ViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    
    @IBAction func registroUsuario(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegistro", sender: self)
    }
}

