//
//  Interactable.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import Foundation
import UIKit

protocol Routerable {
    var viewController: Viewable! { get }

    func dismiss(animated: Bool)
    func dismiss(animated: Bool, completion: @escaping (() -> Void))
    func pop(animated: Bool)
}

extension Routerable {
    func dismiss(animated: Bool) {
        viewController.dismiss(animated: animated)
    }
    func dismiss(animated: Bool, completion: @escaping (() -> Void)) {
        viewController.dismiss(animated: animated, _completion: completion)
    }

    func pop(animated: Bool) {
        viewController.pop(animated: animated)
    }
}
