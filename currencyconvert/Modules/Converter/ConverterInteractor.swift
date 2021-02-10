//
//  ConverterInteractor.swift
//  currencyconvert
//
//  Created by Admin on 09.02.2021.
//

import Foundation
import RxSwift
import RxCocoa

struct ConverterData {
    var inputCurrency: Currency
    var outputCurrency: Currency
    var amount: String
    
    init(_ input: Currency, _ output: Currency, _ amount: String) {
        self.inputCurrency = input
        self.outputCurrency = output
        self.amount = amount
    }
}

class ConverterInteractor {
    let convertedAmount = PublishRelay<String>()
    let errorTrigger = PublishRelay<Error>()

    func convert(data: ConverterData) {
        NetworkService.shared.convert(from: data.inputCurrency, to: data.outputCurrency, amount: data.amount) { [weak self] (amount, error) in
            if let amount = amount {
                self?.convertedAmount.accept(amount)
            } else {
                self?.errorTrigger.accept(error ?? NSError())
            }
        }
    }
}
