//
//  LibroManager.swift
//  BookStore
//
//  Created by Mac5 on 20/01/21.
//

import Foundation

protocol LibroManagerDelegate {
    func actualizarLibro(libro: LibroModelo)
}

struct LibroManager {
    
    var delegado: LibroManagerDelegate?
    
    let libroUrl = "https://www.googleapis.com/books/v1/volumes?key=AIzaSyBG1JcEyo1TfyWVBtEHRNlqCU5yLPbK4UA"
    
    func fetchClima(libro: String){
        let urlString = "\(libroUrl)&q=\(libro.replacingOccurrences(of: " ", with: "%20"))"
        print(urlString)
        
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String){
        //Crear url
        if let url = URL(string: urlString){
            // Crear url session
            let session = URLSession(configuration: .default)
            
            // asignar tarea a la session
            //let tarea = session.dataTask(with: url, completionHandler: handle(data:respuesta:error:))
            let tarea = session.dataTask(with: url) { (data, respuesta, error) in
                if error != nil {
                    print("El error es: \(error!)")
                    return
                }
                if let datosSeguros = data {
                    // decodificar el obj json de la api
                    if let libro = self.parseJSON(libroData: datosSeguros){
                        //Quien sea el delegado cualquier clase o strcut que implemente el metodo actualizaeLibro
                        delegado?.actualizarLibro(libro: libro)
                    }
                }
            }
            
            //empezar tarea
            tarea.resume()
        }
    }
    
    func parseJSON(libroData: Data) -> LibroModelo? {
        let decoder = JSONDecoder()
        do{
            let dataDecodificada = try decoder.decode(LibroData.self , from: libroData)
            //let indice = dataDecodificada.totalItems
            let id = dataDecodificada.items[0].id
            let nombre = dataDecodificada.items[0].volumeInfo.title
            let autor = dataDecodificada.items[0].volumeInfo.authors
            let fechaPub = dataDecodificada.items[0].volumeInfo.publishedDate
            let ObjLibro = LibroModelo(libroId: id, nombreLibro: nombre, autores: autor, fechaPublicacion: fechaPub)
            
            
            return ObjLibro
        }catch{
            print (error)
            return nil
        }
    }
    
}
