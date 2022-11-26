//
//  Extension + UIButton.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import UIKit

extension UIButton {
    convenience init(image: UIImage? = nil, title: String = "", titleColor: UIColor = .white) {
        self.init()
        self.setImage(image, for: .normal)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
    }
}
