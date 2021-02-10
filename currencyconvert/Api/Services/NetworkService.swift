//
//  NetworkService.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class NetworkService {
    
    static let shared = NetworkService()
    let bag = DisposeBag()
    func getAvailableCurrencies(result: @escaping ([Currency]?,Error?) -> Void) {
        Network.request(.getAvailableCurrencies).subscribe (onNext: { (response) in
            do {
                print(response.data)
                try result(JSONDecoder().decode(Currencies.self, from: response.data).currencies.map({Currency(name: $0.value, currencyCode: $0.key)}).sorted(by: { $0.name < $1.name }), nil)
            } catch let error {
                result(nil, error)
            }
            //result(self?.mapJsonToCurrencyArray(data: response.data), nil)
        }, onError: { (error) in
            print(error)
            result(nil, error)
        }).disposed(by: bag)
    }
    
//    func mapJsonToCurrencyArray(data: Data) -> [Currency]? {
//        var currencies: [Currency] = []
//        guard let json = try? JSONDecoder().decode([String : String].self, from: data) else {
//            return nil
//        }
//        currencies = json.map{Currency(name: $0.key, currencyCode: $0.value)}
//        if currencies.isEmpty {
//            return nil
//        }
//        return currencies
//    }
    
    func convert(from: Currency, to: Currency, amount: String, result: @escaping (String?,Error?) -> Void) {
        Network.request(.convert(from: from.currencyCode, to: to.currencyCode, amount: amount)).subscribe (onNext: {(response) in
            do {
                print(response.data.description)
                try result(JSONDecoder().decode(ConvertedCurrency.self, from: response.data).rates[to.currencyCode]?.rateForAmount, nil)
            } catch let error {
                result(nil, error)
            }
            //result(self?.mapJsonToDecimal(data: response.data), nil)
        }, onError: { (error) in
            print(error)
            result(nil, error)
        }).disposed(by: bag)
    }
    
//    func mapJsonToDecimal(data: Data) -> Decimal? {
//        guard let json = try? JSONDecoder().decode(ConvertedCurrency.self, from: data) else {
//            return nil
//        }
//        return nil
//    }
}
