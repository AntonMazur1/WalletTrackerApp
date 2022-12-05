//
//  Extension + UITextField.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String, borderStyle: UITextField.BorderStyle = .none, keyboardType: UIKeyboardType = .default, withBottomLine: Bool = false) {
        self.init()
        self.placeholder = placeholder
        self.borderStyle = borderStyle
        self.keyboardType = keyboardType
        
        if withBottomLine {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 3)
            bottomLine.backgroundColor = UIColor.yellow.cgColor
            self.layer.addSublayer(bottomLine)
        }
    }
}
