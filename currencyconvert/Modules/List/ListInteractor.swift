//
//  ListInteractor.swift
//  currencyconvert
//
//  Created by Admin on 10.02.2021.
//

import Foundation
import RxSwift
import RxCocoa

class ListInteractor {
    let receivedItems = PublishRelay<[Currency]>()
    let errorTrigger = PublishRelay<Error>()
    
    func receiveItems() {
        NetworkService.shared.getAvailableCurrencies { [weak self] (result, error) in
            if let result = result {
                self?.receivedItems.accept(result)
            } else {
                self?.errorTrigger.accept(error ?? NSError())
            }
        }
    }
}
