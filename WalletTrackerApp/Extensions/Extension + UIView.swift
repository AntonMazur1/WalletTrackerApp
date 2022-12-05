//
//  Extension + UIView.swift
//  WalletTrackerApp
//
//  Created by Клоун on 30.11.2022.
//

import UIKit

extension UIView {
    func round(corners: CACornerMask, cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
    }
}
