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
import RxDataSources

class ListViewController: UIViewController, Viewable, UITableViewDelegate, UISearchResultsUpdating {
    
    var presenter: Presentable!

    private let disposeBag = DisposeBag()

    lazy var customView = self.view as? ListView
    
    //var searchBarItem: UIBarButtonItem?
    var searchController: UISearchController?
    
    override func loadView() {
        let view = ListView(frame: CGRect(x: 0.0, y: 0.0, width: 600.0, height: 600.0))
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBarItem = customView?.searchButton
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Поиск валют"
        searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController?.searchBar        //self.definesPresentationContext = true
        //navigationItem.rightBarButtonItem = searchBarItem
        setupRx()
    }
    
    private func setupRx() {
        guard let _presenter = presenter as? ListPresenterInterface else {
            fatalError("AAAAA")
        }
        guard let tableView = customView?.tableView else {
            fatalError("tableView should exist on ListViewContoller")
        }
        _presenter.outputs.viewConfigure
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { () in
                
            })
            .disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
        _presenter.outputs.shownItems.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { index, model, cell in
            cell.textLabel?.text = model.name
          }
          .disposed(by: disposeBag)
        tableView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (ip) in
            _presenter.inputs.cellSelected.accept(ip)
        }).disposed(by: disposeBag)
        
        _presenter.inputs.viewDidLoadTrigger.onNext(())
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let _presenter = presenter as? ListPresenterInterface else {
            fatalError("AAAAA")
        }
        _presenter.inputs.search.accept(searchController.searchBar.text ?? "")
    }
}

