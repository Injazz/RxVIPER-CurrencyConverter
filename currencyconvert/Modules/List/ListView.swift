//
//  ListView.swift
//  currencyconvert
//
//  Created by Admin on 10.02.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ListView : UIView {
    
    private let pageEdgeLoadOffset: CGFloat = 44.0
    
    override var frame: CGRect {
        didSet {
             let pageFrame = pagingIndicator.frame
             let yOffset = tableView.contentSize.height - pageFrame.size.height / 2.0
             let xOffset = (frame.size.width - pageFrame.size.width) / 2.0
             pagingIndicator.frame = CGRect(x: xOffset, y: yOffset, width: pageFrame.size.width, height: pageFrame.size.height)
         }
    }
    
    let searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(UIBarButtonItem.SystemItem.search)
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = CGFloat(400)
        table.backgroundColor = .clear
        table.backgroundView?.backgroundColor = .clear
        table.separatorStyle = .none
        table.estimatedSectionFooterHeight = 16.0
        return table
    }()
    
    let pagingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.hidesWhenStopped = true
        view.stopAnimating()
        return view
    }()
    
    let searchView: UITextField = {
        let field = UITextField()
        return field
    }()
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        
        configureView()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTitle(_ active: LastActiveField) {
        
    }
    
    func configureView() {
    
    }
    
    func addSubviews() {
        addSubview(tableView)
        tableView.addSubview(pagingIndicator)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func page(load: Bool) {
        if load {
            var edge = tableView.contentInset
            edge.bottom += pageEdgeLoadOffset
            tableView.contentInset = edge
            pagingIndicator.startAnimating()
        } else if pagingIndicator.isAnimating {
            var edge = tableView.contentInset
            edge.bottom -= pageEdgeLoadOffset
            tableView.contentInset = edge
            pagingIndicator.stopAnimating()
        }
    }
}
