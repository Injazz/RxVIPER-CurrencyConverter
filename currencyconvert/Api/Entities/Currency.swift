//
//  RapidApiResponse.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import Foundation

struct Currencies : Codable {
    let currencies: [String : String]
    
}

struct Currency : Codable {
    let name : String
    let currencyCode: String
    
    init(name: String, currencyCode: String) {
        self.name = name
        self.currencyCode = currencyCode
    }
}
