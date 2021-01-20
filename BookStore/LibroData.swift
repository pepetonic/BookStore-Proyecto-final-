//
//  LibroData.swift
//  BookStore
//
//  Created by Mac5 on 20/01/21.
//

import Foundation

struct LibroData: Codable {
    let kind: String
    let totalItems: Int
    let items: [Item]
}

struct Item: Codable {
    let kind: String
    let id: String
}
