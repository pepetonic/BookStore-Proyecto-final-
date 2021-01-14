//
//  loginViewController.swift
//  BookStore
//
//  Created by Mac5 on 13/01/21.
//

import UIKit
import FirebaseAuth

class loginViewController: UIViewController {

    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var contraTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func loginToMenu(_ sender: Any) {
        if let email = correoTextField.text, let password = contraTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                //guard let strongSelf = self else { return }
                if let e = error {
                    print(e.localizedDescription )
                }else{
                    //login a firebase
                    if let respuestaFirebase = authResult {
                        print ("\(respuestaFirebase.user) inicio sesión")
                        self.performSegue(withIdentifier: "toMenu", sender: self)
                    }
                }
                
            }
        }
    }
}
