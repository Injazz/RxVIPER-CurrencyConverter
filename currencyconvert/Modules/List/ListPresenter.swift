//
//  ListPresenter.swift
//  currencyconvert
//
//  Created by Admin on 10.02.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol ListPresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var cellSelected: PublishRelay<IndexPath> { get }
    var search: PublishRelay<String> { get }
    var allItems: BehaviorRelay<[Currency]> { get }
}

protocol ListPresenterOutputs {
    var viewConfigure: Observable<Void> { get }
    var shownItems: Observable<[Currency]> { get }
    var errorToShow: Observable<Error> { get }
}

protocol ListPresenterInterface: Presentable {
    var inputs: ListPresenterInputs { get }
    var outputs: ListPresenterOutputs { get }
}

typealias ListPresenterDependencies = (
    interactor: ListInteractor,
    router: ListRouter
)



final class ListPresenter: ListPresenterInterface, ListPresenterInputs, ListPresenterOutputs {
    
    var inputs: ListPresenterInputs { return self }
    var outputs: ListPresenterOutputs { return self }

    // Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let cellSelected = PublishRelay<IndexPath>()
    let search = PublishRelay<String>()

    // Outputs
    let viewConfigure: Observable<Void>
    let allItems: BehaviorRelay<[Currency]>
    let errorToShow: Observable<Error>
    let shownItems: Observable<[Currency]>

    private let dependencies: ListPresenterDependencies
    private let disposeBag = DisposeBag()

    init(dependencies: ListPresenterDependencies) {
        self.dependencies = dependencies

        let _viewConfigure = PublishRelay<Void>()
        self.viewConfigure = _viewConfigure.asObservable().take(1)
        let _allItems = BehaviorRelay<[Currency]>(value: [])
        self.allItems = _allItems
        let _shownItems = BehaviorRelay<[Currency]>(value:[])
        self.shownItems = _shownItems.asObservable()
        let _errorToShow = PublishRelay<Error>()
        self.errorToShow = _errorToShow.asObservable()
        
        // MARK:- Filling list
        dependencies.interactor.receivedItems.subscribe (onNext: { (items) in
            _allItems.accept(items)
            _shownItems.accept(items)
        }, onError: { (error) in
            _errorToShow.accept(error)
        }).disposed(by: disposeBag)
        
        // MARK:- Input
        cellSelected.subscribe (onNext: { [weak self] (ip) in
            let selectedCurrency = _shownItems.value[ip.row]
            self?.dependencies.router.prepareForPop(item: selectedCurrency)
        }, onError: { (error) in
            _errorToShow.accept(error)
        }).disposed(by: disposeBag)
        
        search.subscribe(onNext: { (searchString) in
            
        }).disposed(by: disposeBag)
        
        search.asObservable().subscribe(onNext: { (query) in
            if(query.isEmpty) {
                _shownItems.accept(_allItems.value)
            } else {
                _shownItems.accept(_allItems.value.filter({$0.name.lowercased().contains(query.lowercased())}))
            }
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)

        
        // MARK:- Configuration successful
        viewDidLoadTrigger.asObservable().subscribe(onNext: { () in
            dependencies.interactor.receiveItems()
            _viewConfigure.accept(())
        }).disposed(by: disposeBag)
    }
}
