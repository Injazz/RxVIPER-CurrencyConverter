//
//  RapidApi.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import Foundation
import Moya

enum RapidApi {
    case getAvailableCurrencies
    case convert(from: String, to: String, amount: String)
}

extension RapidApi: TargetType {
    var path: String {
        switch self {
        case .getAvailableCurrencies:
            return "currency/list"
        case .convert:
            return "currency/convert"
        }
    }
    
    var parameters: [String : Any]? {
        var params : [String : Any] = [:]
        switch self {
        case .getAvailableCurrencies:
            params["format"] = "json"
            params["language"] = "ru"
        case .convert(let from, let to, let amount):
            params["language"] = "en"
            params["format"] = "json"
            params["from"] = from
            params["to"] = to
            params["amount"] = amount
        }
        return params
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: (parameters) ?? [:], encoding: URLEncoding())
    }
    
    var headers: [String : String]? {
        return ["x-rapidapi-host": "currency-converter5.p.rapidapi.com",
                "x-rapidapi-key": "<insert-key-here>"] // MARK:- removed the key for GitHub release
    }
    
    var baseURL: URL {
            return URL(string: "https://currency-converter5.p.rapidapi.com")!
    }
    
    var url: String {
        if path.count > 0 {
            return "\(baseURL)/\(path)"
        } else {
            return "\(baseURL)"
        }
    }
}


extension RapidApi: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.returnCacheDataElseLoad
    }
}
