//
//  AppRouter.swift
//  currencyconvert
//
//  Created by Admin on 10.02.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AppRouter {
    static let shared = AppRouter()
    
    var converterRouter : ConverterRouter!
    var listRouter : ListRouter?
    
    init() {
        let conVc = ConverterViewController()
        let nc = UINavigationController(rootViewController: conVc)
        converterRouter = ConverterRouter(conVc, nc)
        
    }
    
    func startRouting(window: UIWindow) {
        //test
        let inputCurrency = Currency(name: "United States dollar", currencyCode: "USD")
        let outputCurrency = Currency(name: "Russian ruble", currencyCode: "RUB")
        let entryEntity = ConverterEntryEntity(inputCurrency: inputCurrency, outputCurrency: outputCurrency)
        window.rootViewController = converterRouter.setup(entryEntity: entryEntity)
        window.makeKeyAndVisible()
    }
    
    func startList(nav: UINavigationController) {
        listRouter = ListRouter(nav)
        listRouter?.push(from: nav)
    }
    
    func popList(currency: Currency) {
        listRouter?.pop()
        guard let presenter = converterRouter.viewController.presenter as? ConverterPresenterInterface else {
            fatalError("RABOTAYY")
        }
        
        presenter.inputs.currencyChosen.accept(currency)
    }
}
