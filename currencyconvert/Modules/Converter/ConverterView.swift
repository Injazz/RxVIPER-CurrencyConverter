//
//  ConverterView.swift
//  currencyconvert
//
//  Created by Admin on 09.02.2021.
//

import Foundation
import UIKit
import SnapKit

class ConverterView: UIView {
    
    var innerView: UIView = {
        let fitView = UIView()
        fitView.translatesAutoresizingMaskIntoConstraints = false
        //fitView.backgroundColor = .white
        return fitView
    }()
    
    var inputRow: UIView = {
        let inputView = UIView()
        //inputView.backgroundColor = .yellow
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    var inputWindow: UITextField = {
        let inputField = UITextField()
        inputField.backgroundColor = .red
        inputField.keyboardType = UIKeyboardType.decimalPad
        inputField.autocorrectionType = UITextAutocorrectionType.no
        inputField.spellCheckingType = UITextSpellCheckingType.no
        inputField.backgroundColor = .white
        inputField.textColor = .black
        inputField.layer.cornerRadius = 12
        inputField.translatesAutoresizingMaskIntoConstraints = false
        return inputField
    }()
    
    var inputCurrencyList: UIButton = {
        let inputButton = UIButton()
        inputButton.backgroundColor = .systemGreen
        inputButton.layer.cornerRadius = 12
        inputButton.setTitleColor(.black, for: .normal)
        inputButton.translatesAutoresizingMaskIntoConstraints = false
        return inputButton
    }()
    
    var outputRow: UIView = {
        let outputView = UIView()
        //outputView.backgroundColor = .green
        outputView.translatesAutoresizingMaskIntoConstraints = false
        return outputView
    }()
    
    var outputWindow: UITextField = {
        let outputField = UITextField()
        outputField.backgroundColor = .white
        outputField.textColor = .black
        outputField.layer.cornerRadius = 12
        outputField.keyboardType = UIKeyboardType.decimalPad
        outputField.autocorrectionType = UITextAutocorrectionType.no
        outputField.spellCheckingType = UITextSpellCheckingType.no
        outputField.translatesAutoresizingMaskIntoConstraints = false
        return outputField
    }()
    
    var outputCurrencyList: UIButton = {
        let outputButton = UIButton()
        outputButton.backgroundColor = .systemGreen
        outputButton.layer.cornerRadius = 12
        outputButton.setTitleColor(.black, for: .normal)
        outputButton.translatesAutoresizingMaskIntoConstraints = false
        return outputButton
    }()
    
    var buttonRow: UIView = {
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        //buttonView.backgroundColor = .blue
        return buttonView
    }()
    
    var convertButton: UIButton = {
        let convButton = UIButton()
        convButton.setTitle("Сначала введите значение", for: .normal)
        convButton.isEnabled = false
        convButton.translatesAutoresizingMaskIntoConstraints = false
        return convButton
    }()
    
    var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.alpha = 0
        return indicator
    }()
    
    var inputLoadingRow: UIView = {
        let inputView = UIView()
        inputView.backgroundColor = .darkGray
        inputView.layer.cornerRadius = 12
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.alpha = 0
        return inputView
    }()
    
    var outputLoadingRow: UIView = {
        let inputView = UIView()
        inputView.backgroundColor = .darkGray
        inputView.layer.cornerRadius = 12
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.alpha = 0
        return inputView
    }()
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        //backgroundColor = UIColor.white
        addSubviews()
        makeConstraints()
        self.layoutIfNeeded()
    }
    
    private func addSubviews() {
        addSubview(innerView)
        setupInputRow()
        setupOutputRow()
        setupButtonRow()
    }
    
    private func setupInputRow() {
        innerView.addSubview(inputRow)
        inputRow.addSubview(inputCurrencyList)
        inputRow.addSubview(inputWindow)
        inputRow.addSubview(inputLoadingRow)
    }
    
    private func setupOutputRow() {
        innerView.addSubview(outputRow)
        outputRow.addSubview(outputCurrencyList)
        outputRow.addSubview(outputWindow)
        outputRow.addSubview(outputLoadingRow)
    }
    
    private func setupButtonRow() {
        innerView.addSubview(buttonRow)
        buttonRow.addSubview(convertButton)
        buttonRow.addSubview(indicatorView)
    }
    
    private func makeConstraints() {
        makeInnerViewConstraints()
        makeInputRowConstraints()
        makeOutputRowConstraints()
        makeButtonRowConstraints()
        makeLoadingRowConstraints()
    }
    
    private func makeInnerViewConstraints() {
        innerView.snp.makeConstraints({ (maker) -> Void in
            maker.top.equalToSuperview().offset(72.0)
            maker.left.right.equalToSuperview()
            maker.height.lessThanOrEqualTo(400)
        })
    }
    private func makeInputRowConstraints() {
        inputRow.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(70)
        }
        inputCurrencyList.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(8)
            maker.width.equalTo(96)
            maker.bottom.equalToSuperview().inset(4)
            maker.top.equalToSuperview().offset(4)
        }
        inputWindow.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().inset(8)
            maker.left.equalTo(inputCurrencyList.snp.right).offset(8)
            maker.bottom.equalToSuperview().inset(4)
            maker.top.equalToSuperview().offset(4)
        }
    }
    
    private func makeOutputRowConstraints() {
        outputRow.snp.makeConstraints { (maker) in
            maker.top.equalTo(inputRow.snp.bottom)
            maker.left.right.equalTo(self)
            maker.height.equalTo(70)
        }
        outputCurrencyList.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(8)
            maker.width.equalTo(96)
            maker.bottom.equalToSuperview().inset(4)
            maker.top.equalToSuperview().offset(4)
        }
        outputWindow.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().inset(8)
            maker.left.equalTo(outputCurrencyList.snp.right).offset(8)
            maker.bottom.equalToSuperview().inset(4)
            maker.top.equalToSuperview().offset(4)
        }
    }
    
    private func makeButtonRowConstraints() {
        buttonRow.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.height.equalTo(70)
            maker.top.equalTo(outputRow.snp.bottom)
        }
        convertButton.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
        indicatorView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func makeLoadingRowConstraints() {
        inputLoadingRow.snp.makeConstraints({ (maker) -> Void in
            maker.right.equalToSuperview().inset(8)
            maker.left.equalToSuperview().offset(8)
            maker.bottom.equalToSuperview().inset(4)
            maker.top.equalToSuperview().offset(4)
        })
        outputLoadingRow.snp.makeConstraints({ (maker) -> Void in
            maker.right.equalToSuperview().inset(8)
            maker.left.equalToSuperview().offset(8)
            maker.bottom.equalToSuperview().inset(4)
            maker.top.equalToSuperview().offset(4)
        })
    }
    
    func setCurrencyLabels(entity: ConverterEntryEntity) {
        inputCurrencyList.setTitle( entity.inputCurrency.currencyCode, for: .normal)
        outputCurrencyList.setTitle(entity.outputCurrency.currencyCode, for: .normal)
    }
    
    func updateCurrencyLabel(_ code: String, _ isFirstRow:Bool ) {
        if isFirstRow {
            inputCurrencyList.setTitle(code, for: .normal)
        } else {
            outputCurrencyList.setTitle(code, for: .normal)
        }
    }
    
    func fillConvertData(_ priority: LastActiveField) -> (String)? {
        if let _ = inputCurrencyList.title(for: .normal),
           let _ = outputCurrencyList.title(for: .normal) {
            if let firstRowInput = inputWindow.text, !firstRowInput.isEmpty, priority == .first {
                return (firstRowInput)
            } else if let secondRowInput = outputWindow.text, !secondRowInput.isEmpty, priority == .second {
                return (secondRowInput)
            }
        }
        return nil
    }
    
    func setConvertedAmount(_ activeWindow: LastActiveField, _ amount: String) {
        switch activeWindow {
        case .first:
            outputWindow.text = amount
        case .second:
            inputWindow.text = amount
        }
    }
    
    func startLoading() {
        inputLoadingRow.alpha = 0.5
        outputLoadingRow.alpha = 0.5
        convertButton.alpha = 0
        indicatorView.alpha = 1
        indicatorView.startAnimating()
    }
    
    func stopLoading() {
        inputLoadingRow.alpha = 0
        outputLoadingRow.alpha = 0
        convertButton.alpha = 1
        indicatorView.alpha = 0
        indicatorView.stopAnimating()
    }
}

