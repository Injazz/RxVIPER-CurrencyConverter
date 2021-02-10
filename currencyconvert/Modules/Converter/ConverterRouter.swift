//
//  ConverterRouter.swift
//  currencyconvert
//
//  Created by Admin on 09.02.2021.
//

import Foundation
import UIKit

struct ConverterEntryEntity {
    let inputCurrency: Currency
    let outputCurrency: Currency
    init(inputCurrency: Currency, outputCurrency: Currency) {
        self.inputCurrency = inputCurrency
        self.outputCurrency = outputCurrency
    }
}

final class ConverterRouter: Routerable {
    internal weak var viewController: Viewable!
    private weak var navController: UINavigationController!

    init(_ viewController: Viewable, _ navController: UINavigationController) {
        self.viewController = viewController
        self.navController = navController
    }
    
    func setup(entryEntity: ConverterEntryEntity) -> UINavigationController {
        let interactor = ConverterInteractor()
        let dependencies = ConverterPresenterDependencies(interactor: interactor, router: self)
        let presenter = ConverterPresenter(entryEntity: entryEntity, dependencies: dependencies)
        viewController.presenter = presenter
        return navController
    }
    
    func transitionList() {
        AppRouter.shared.startList(nav: navController)
    }
}
