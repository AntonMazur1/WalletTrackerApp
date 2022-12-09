//
//  HomeViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    func getConsumptionCellViewModel(with consumption: ConsumptionTypeModel) -> ConsumptionTableViewCellViewModelProtocol?
}

class HomeViewModel: HomeViewModelProtocol {
    func getConsumptionCellViewModel(with consumption: ConsumptionTypeModel) -> ConsumptionTableViewCellViewModelProtocol? {
        ConsumptionTableViewCellViewModel(consumptionName: consumption.title,
                                          consumptionPrice: consumption.price)
    }
}
