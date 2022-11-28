//
//  Extension + CGFloat.swift
//  WalletTrackerApp
//
//  Created by Клоун on 28.11.2022.
//

import Foundation

extension CGFloat {
    static func random() -> CGFloat {
        CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
