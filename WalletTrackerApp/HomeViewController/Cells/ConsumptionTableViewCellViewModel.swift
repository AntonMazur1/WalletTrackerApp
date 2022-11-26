//
//  ConsumptionTableViewCellViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 26.11.2022.
//

import Foundation

protocol ConsumptionTableViewCellViewModelProtocol {
    var consumptionName: String { get }
}

class ConsumptionTableViewCellViewModel: ConsumptionTableViewCellViewModelProtocol {
    var consumptionName: String
    
    init(consumptionName: String) {
        self.consumptionName = consumptionName
    }
}
