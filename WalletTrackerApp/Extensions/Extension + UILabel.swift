//
//  Extension + UILabel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 26.11.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor = .black, isHidden: Bool = false) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.isHidden = isHidden
    }
}
