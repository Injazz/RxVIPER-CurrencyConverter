//
//  ConverterViewController.swift
//  currencyconvert
//
//  Created by Admin on 08.02.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ConverterViewController: UIViewController, Viewable, BackTransferable {

    var presenter: Presentable!
    
    private let disposeBag = DisposeBag()
    
    // IBOutlet & UI
    lazy var customView = self.view as? ConverterView
    
    // MARK: - View lifecycle
    override func loadView() {
        let view = ConverterView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    private func setupRx() {
        guard let _presenter = presenter as? ConverterPresenterInterface else {
            fatalError("AAAAA")
        }
        customView?.convertButton.rx.tap.asObservable().subscribe(onNext: {[weak customView, weak self] in
            if let data = customView?.fillConvertData(_presenter.inputs.activeWindowChange.value ?? .first) {
                _presenter.inputs.convertButtonPressed.onNext(data)
                customView?.startLoading()
            } else {
                print("Should show alert here")
            }
        }, onError: { (error) in
            print(error)
        })
        .disposed(by: disposeBag)
        
        customView?.inputWindow.rx.controlEvent([.editingDidBegin]).asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak customView, weak self] in
                customView?.outputWindow.text = nil
                _presenter.inputs.activeWindowChange.accept(.first)
        }).disposed(by: disposeBag)
        
        customView?.inputWindow.rx.text
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak customView] text in
                if let text = text, !text.isEmpty {
                    customView?.convertButton.setTitle("Конвертировать", for: .normal)
                    customView?.convertButton.isEnabled = true
                } else {
                    customView?.convertButton.setTitle("Сначала введите значение", for: .normal)
                    customView?.convertButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
        
        customView?.outputWindow.rx.controlEvent([.editingDidBegin]).asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak customView, weak self] in
                customView?.inputWindow.text = nil
                _presenter.inputs.activeWindowChange.accept(.second)
        }).disposed(by: disposeBag)
        
        customView?.outputWindow.rx.text
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak customView] text in
                if let text = text, !text.isEmpty {
                    customView?.convertButton.setTitle("Конвертировать", for: .normal)
                    customView?.convertButton.isEnabled = true
                } else {
                    customView?.convertButton.setTitle("Сначала введите значение", for: .normal)
                    customView?.convertButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
        
        customView?.inputCurrencyList.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                _presenter.inputs.activeCurrencyListChange.accept(.first)
                _presenter.inputs.currencyButtonPressed.accept(())
            }).disposed(by: disposeBag)
        
        customView?.outputCurrencyList.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                _presenter.inputs.activeCurrencyListChange.accept(.second)
                _presenter.inputs.currencyButtonPressed.accept(())
            }).disposed(by: disposeBag)
        
        _presenter.outputs.viewConfigure
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak customView] entryEntity in
                customView?.setCurrencyLabels(entity: entryEntity)
            })
            .disposed(by: disposeBag)
        
        _presenter.outputs.convertedAmountReceived
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak customView, weak self] (amount) in
                customView?.stopLoading()
                let activeWindow = _presenter.inputs.activeWindowChange.value
                customView?.setConvertedAmount(activeWindow, amount)
            })
            .disposed(by: disposeBag)
        
        _presenter.outputs.errorReceived
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak customView] (error) in
                customView?.stopLoading()
                //customView?.showError(error)
            })
            .disposed(by: disposeBag)
        
        _presenter.outputs.changeCurrencyLabel
            .observeOn(MainScheduler.asyncInstance)
            .subscribe (onNext: { [weak customView] (currency) in
                switch(_presenter.inputs.activeCurrencyListChange.value) {
                case .first:
                    customView?.inputCurrencyList.setTitle(currency.currencyCode, for: .normal)
                case .second:
                    customView?.outputCurrencyList.setTitle(currency.currencyCode, for: .normal)
                }
            }, onError: { (error) in
                print(error)
            }).disposed(by: disposeBag)

        
        _presenter.inputs.viewDidLoadTrigger.onNext(())
    }
    
    func passData() {
        
    }
}
