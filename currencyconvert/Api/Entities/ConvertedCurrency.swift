//
//  ConvertedResult.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import Foundation

struct ConvertedCurrency : Codable {
    let amount: String
    let baseCurrencyCode: String
    let baseCurrencyName: String
    let rates: [String: CurrencyRate]
    let status: String
    let updatedDate: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case status
        case rates
        case updatedDate = "updated_date"
        case baseCurrencyCode = "base_currency_code"
        case baseCurrencyName = "base_currency_name"
    }
}

struct CurrencyRate : Codable {
    let name: String
    let rate: String
    let rateForAmount: String
    
    enum CodingKeys: String, CodingKey {
        case name = "currency_name"
        case rate
        case rateForAmount = "rate_for_amount"
    }
}
