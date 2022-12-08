//
//  HomeViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    func getColor(with type: ConsumptionType?) -> (red: CGFloat, green: CGFloat, blue: CGFloat)
}

class HomeViewModel: HomeViewModelProtocol {
    func getColor(with type: ConsumptionType?) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        switch type {
        case .travell:
            return (red: 1, green: 0.5, blue: 0)
        case .shopping:
            return (red: 1, green: 1, blue: 0)
        case .rent:
            return (red: 1, green: 0, blue: 0)
        case .grocery:
            return (red: 0, green: 1, blue: 0)
        case .none:
            return (red: 1, green: 1, blue: 1)
        }
    }
    
//    func getNumberOfSegments() -> [CGFloat] {
//        consumptions.keys.map { (CGFloat(consumptions[$0]?.count ?? 0)) }
//    }
}
