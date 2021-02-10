//
//  UImage.swift
//  currencyconvert
//
//  Created by Admin on 10.02.2021.
//

import Foundation
import UIKit

extension UIImage {

    public convenience init?(_ systemItem: UIBarButtonItem.SystemItem) {

        guard let sysImage = UIImage.imageFrom(systemItem: systemItem)?.cgImage else {
            return nil
        }

        self.init(cgImage: sysImage)
    }

    private class func imageFrom(systemItem: UIBarButtonItem.SystemItem) -> UIImage? {

        let sysBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)

        //MARK:- Adding barButton into tool bar and rendering it.
        let toolBar = UIToolbar()
        toolBar.setItems([sysBarButtonItem], animated: false)
        toolBar.snapshotView(afterScreenUpdates: true)

        if  let buttonView = sysBarButtonItem.value(forKey: "view") as? UIView{
            for subView in buttonView.subviews {
                if subView is UIButton {
                    let button = subView as! UIButton
                    let image = button.imageView!.image!
                    return image
                }
            }
        }
        return nil
    }
}
