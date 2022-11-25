//
//  Extension + UIButton.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import UIKit

extension UIButton {
    convenience init(image: UIImage) {
        self.init()
        self.setImage(image, for: .normal)
    }
}
