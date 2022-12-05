//
//  ConsumptionTableViewCellViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 26.11.2022.
//

import Foundation

protocol ConsumptionTableViewCellViewModelProtocol {
    var consumptionName: String { get }
    var consumptionPrice: String { get }
}

class ConsumptionTableViewCellViewModel: ConsumptionTableViewCellViewModelProtocol {
    var consumptionName: String
    var consumptionPrice: String
    
    init(consumptionName: String, consumptionPrice: String) {
        self.consumptionName = consumptionName
        self.consumptionPrice = consumptionPrice
    }
}
