//
//  WhisListViewController.swift
//  BookStore
//
//  Created by Mac5 on 17/01/21.
//

import UIKit

class WhisListViewController: UIViewController {

    @IBOutlet weak var tablaLibros: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //Celda personalizada
        tablaLibros.dataSource = self
        tablaLibros.delegate = self
        tablaLibros.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
    }
    

    

}


extension WhisListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objCelda = tablaLibros.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        //if libroBuscado == nil{
            objCelda.libroLabel.text = ""
            objCelda.autorLabel.text = ""
            objCelda.imageView?.image = #imageLiteral(resourceName: "libro")
            return objCelda
       /* } else {
            objCelda.libroLabel.text = libroBuscado?.nombreLibro
            objCelda.autorLabel.text = libroBuscado?.autores[0]
            return objCelda
        }*/
    }
}
