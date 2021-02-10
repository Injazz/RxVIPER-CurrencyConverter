//
//  ListRouter.swift
//  currencyconvert
//
//  Created by Admin on 10.02.2021.
//

import Foundation
import UIKit

final class ListRouter: Routerable {

    private(set) var viewController: Viewable!
    private(set) weak var navigationController: UINavigationController!
    var backTransferDelegate: BackTransferable?
    private var interactor = ListInteractor()
    
    init(_ navController: UINavigationController) {
        self.viewController = ListViewController()
        self.navigationController = navController
    }
    
    private func viewController(string: String) -> ListViewController {
        let dependencies = ListPresenterDependencies(interactor: interactor, router: self)
        let presenter = ListPresenter(dependencies: dependencies)
        self.viewController.presenter = presenter
        let viewController = self.viewController as! ListViewController
        return viewController
    }

    func push(from: UINavigationController) {
        from.pushViewController(viewController(string: "test"), animated: true)
    }
    
    func prepareForPop(item: Currency) {
        AppRouter.shared.popList(currency: item)
    }
    
    func pop() {
        self.backTransferDelegate?.passData()
        navigationController.popViewController(animated: true)
    }
}
