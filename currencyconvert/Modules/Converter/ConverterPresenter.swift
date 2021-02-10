//
//  ConverterPresenter.swift
//  currencyconvert
//
//  Created by Admin on 09.02.2021.
//

import Foundation
import RxCocoa
import RxSwift

enum LastActiveField {
    case first
    case second
}

protocol ConverterPresenterInputs {
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var convertButtonPressed: PublishSubject<String> { get }
    var activeWindowChange: BehaviorRelay<LastActiveField> { get }
    var activeCurrencyListChange: BehaviorRelay<LastActiveField> { get }
    var currencyChosen: PublishRelay<Currency> { get }
    var currencyButtonPressed: PublishRelay<Void> { get }
}

protocol ConverterPresenterOutputs {
    var viewConfigure: Observable<ConverterEntryEntity> { get }
    var convertedAmountReceived: Observable<String> { get }
    var errorReceived: Observable<Error> { get }
    var changeCurrencyLabel: Observable<Currency> { get }
    
}

protocol ConverterPresenterInterface : Presentable {
    var inputs: ConverterPresenterInputs { get }
    var outputs: ConverterPresenterOutputs { get }
}

typealias ConverterPresenterDependencies = (
    interactor: ConverterInteractor,
    router: ConverterRouter
)



final class ConverterPresenter: ConverterPresenterInterface, ConverterPresenterInputs, ConverterPresenterOutputs {
    var inputs: ConverterPresenterInputs { return self }
    var outputs: ConverterPresenterOutputs { return self }

    // Inputs
    let viewDidLoadTrigger = PublishSubject<Void>()
    let convertButtonPressed = PublishSubject<String>()
    let activeWindowChange : BehaviorRelay<LastActiveField> = BehaviorRelay(value: .first)
    let activeCurrencyListChange = BehaviorRelay<LastActiveField>(value: .first)
    let currencyChosen = PublishRelay<Currency>()
    let currencyButtonPressed = PublishRelay<Void>()
    
    // Outputs
    let viewConfigure: Observable<ConverterEntryEntity>
    let convertedAmountReceived: Observable<String>
    let errorReceived: Observable<Error>
    let changeCurrencyLabel: Observable<Currency>

    private var entryEntity: ConverterEntryEntity
    private let dependencies: ConverterPresenterDependencies
    private let disposeBag = DisposeBag()

    init(entryEntity: ConverterEntryEntity, dependencies: ConverterPresenterDependencies) {
        self.entryEntity = entryEntity
        self.dependencies = dependencies

        let _viewConfigure = PublishRelay<ConverterEntryEntity>()
        self.viewConfigure = _viewConfigure.asObservable().take(1)
        let _convertedAmountReceived = PublishRelay<String>()
        self.convertedAmountReceived = _convertedAmountReceived.asObservable()
        let _errorReceived = PublishRelay<Error>()
        self.errorReceived = _errorReceived.asObservable()
        let _changeCurrencyLabel = PublishRelay<Currency>()
        self.changeCurrencyLabel = _changeCurrencyLabel.asObservable()
        
        currencyChosen.asObservable().subscribe (onNext: { [unowned self] (currency) in
            let oldEntry = self.entryEntity
            switch self.activeCurrencyListChange.value {
            case .first:
                self.entryEntity = ConverterEntryEntity(inputCurrency: currency, outputCurrency: oldEntry.outputCurrency)
            case .second:
                self.entryEntity = ConverterEntryEntity(inputCurrency: oldEntry.inputCurrency, outputCurrency: currency)
            }
            _changeCurrencyLabel.accept(currency)
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)

        
        convertButtonPressed.asObservable().subscribe (onNext: { [weak self] (amount) in
            switch self?.activeWindowChange.value {
            case .first:
                dependencies.interactor.convert(data: ConverterData(self?.entryEntity.inputCurrency ??  Currency(name: "", currencyCode: ""), self?.entryEntity.outputCurrency ?? Currency(name: "", currencyCode: ""), amount))
            case .second:
                dependencies.interactor.convert(data: ConverterData(self?.entryEntity.outputCurrency ?? Currency(name: "", currencyCode: ""), self?.entryEntity.inputCurrency ?? Currency(name: "", currencyCode: ""), amount))
            case .none:
                print("what")
            }
        }, onError: { (error) in
            print(error)
        }).disposed(by: disposeBag)

        // MARK:- Network
        dependencies.interactor.convertedAmount.asObservable().subscribe (onNext: { (amount) in
            _convertedAmountReceived.accept(amount)
        }, onError: { (error) in
            _errorReceived.accept(error)
        }).disposed(by: disposeBag)

        dependencies.interactor.errorTrigger.asObservable().subscribe (onNext: { (error) in
            _errorReceived.accept(error)
        }).disposed(by: disposeBag)
        
        // MARK:- Routing
        currencyButtonPressed.asObservable().subscribe(onNext: { () in
            dependencies.router.transitionList()
            
        }).disposed(by: disposeBag)
        
        // MARK:- Configuration successful
        viewDidLoadTrigger.asObservable().subscribe(onNext: { () in
                _viewConfigure.accept(entryEntity)
        }).disposed(by: disposeBag)
    }
}
