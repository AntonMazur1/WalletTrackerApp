//
//  Extension + UIColor.swift
//  WalletTrackerApp
//
//  Created by Клоун on 28.11.2022.
//

import UIKit

extension UIColor {
    static func getColor(type: ConsumptionType) -> UIColor {
        switch type {
        case .travell:
            return .red
        case .shopping:
            return .yellow
        case .rent:
            return .blue
        case .grocery:
            return .green
        }
    }
}
