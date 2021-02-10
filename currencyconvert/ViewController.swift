//
//  ViewController.swift
//  currencyconvert
//
//  Created by Admin on 07.02.2021.
//

import UIKit

class ViewController: UIViewController {

    lazy var box = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(box)
        box.backgroundColor = .green
        box.snp.makeConstraints { (make) -> Void in
           make.width.height.equalTo(50)
           make.center.equalTo(self.view)
        }
    }


}

