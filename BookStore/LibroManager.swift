//
//  LibroManager.swift
//  BookStore
//
//  Created by Mac5 on 20/01/21.
//

import Foundation

struct LibroManager {
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
                    print(error!)
                    return
                }
                if let datosSeguros = data {
                    // decodificar el obj json de la api
                    parseJSON(libroData: datosSeguros)
                }
            }
            
            //empezar tarea
            tarea.resume()
        }
    }
    
    func parseJSON(libroData: Data){
        let decoder = JSONDecoder()
        do{
           let dataDecodificada = try decoder.decode(LibroData.self , from: libroData)
            print(dataDecodificada.kind)
            print(dataDecodificada.totalItems)
            print(dataDecodificada.items.first!.id)
        }catch{
            print (error)
        }
    }
    
}
