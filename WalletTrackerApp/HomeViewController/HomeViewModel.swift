//
//  HomeViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    var numberOfSections: Int { get }
    func getNumberOfRows(at section: Int) -> Int
    func save(consumption: ConsumptionTypeModel)
    func getConsumptionCellViewModel(at indexPath: IndexPath) -> ConsumptionTableViewCellViewModelProtocol?
}

class HomeViewModel: HomeViewModelProtocol {
    private var consumptions = [
        [ConsumptionTypeModel(title: "Travelling", type: .travell, createDate: Date()),
         ConsumptionTypeModel(title: "Products", type: .shopping, createDate: Date())],
        
        [ConsumptionTypeModel(title: "new", type: .travell, createDate: Date()),
         ConsumptionTypeModel(title: "olo", type: .shopping, createDate: Date())]
    ]
    
    var numberOfSections: Int {
        consumptions.count
    }
    
    func save(consumption: ConsumptionTypeModel) {
        
    }
    
    func getNumberOfRows(at section: Int) -> Int {
        consumptions[section].count
    }
    
    func getTitleForHeader(at section: Int) -> String {
        if let firstConsumption = consumptions[section].first {
            return firstConsumption.createDate.description
        }
        
        return "No"
    }
    
    func getConsumptionCellViewModel(at indexPath: IndexPath) -> ConsumptionTableViewCellViewModelProtocol? {
        let consumption = consumptions[indexPath.section][indexPath.row]
        return ConsumptionTableViewCellViewModel(consumptionName: consumption.title)
    }
}
