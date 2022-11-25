//
//  Extension + UIStackView.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView],
                     axis: NSLayoutConstraint.Axis,
                     distributon: UIStackView.Distribution = .fillProportionally,
                     spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.distribution = distributon
        self.spacing = spacing
    }
}
