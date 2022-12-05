//
//  HomeViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    var numberOfSections: Int { get }
    func filterConsumptionsByPrice(completion: () -> Void)
    func getNumberOfSegments() -> [CGFloat]
    func getNumberOfRows(at section: Int) -> Int
    func save(consumption: ConsumptionTypeModel, completion: () -> ())
    func deleteConsumption(at indexPath: IndexPath)
    func getConsumptionCellViewModel(at indexPath: IndexPath) -> ConsumptionTableViewCellViewModelProtocol?
}

class HomeViewModel: HomeViewModelProtocol {
    private var consumptions: [ConsumptionType: [ConsumptionTypeModel]] = [:]
    
    var numberOfSections: Int {
        consumptions.keys.count
    }
    
    func save(consumption: ConsumptionTypeModel, completion: () -> ()) {
        consumptions[consumption.type] == nil
        ? consumptions[consumption.type] = [consumption]
        : consumptions[consumption.type]?.append(consumption)
        
        completion()
    }
    
    func deleteConsumption(at indexPath: IndexPath) {
        let consumption = Array(consumptions)[indexPath.section]
        let consumptionForRemove = consumption.value[indexPath.row]
        
        if let index = consumptions[consumption.key]?.firstIndex(of: consumptionForRemove) {
            consumptions[consumption.key]?.remove(at: index)
            guard let _ = consumptions[consumption.key]?.isEmpty else { return }
            consumptions.removeValue(forKey: consumption.key)
        }
    }
    
    func filterConsumptionsByPrice(completion: () -> Void) {
        let sort = consumptions.mapValues { $0.sorted { $0.price < $1.price } }
        consumptions = sort
        completion()
    }
    
    func getNumberOfSegments() -> [CGFloat] {
        consumptions.keys.map( { (CGFloat(consumptions[$0]?.count ?? 0)) } )
    }
    
    func getNumberOfRows(at section: Int) -> Int {
        let datesSections = Array(consumptions.keys)
        return consumptions[datesSections[section]]?.count ?? 0
    }
    
    func getTitleForHeader(at section: Int) -> String {
        let itemsInSections = Array(consumptions.values)
        guard let dateHeader = itemsInSections[section].first else { return "" }
        
        return dateHeader.type.rawValue
    }
    
    func getConsumptionCellViewModel(at indexPath: IndexPath) -> ConsumptionTableViewCellViewModelProtocol? {
        let datesSections = Array(consumptions.keys)
        guard let consumptionSection = consumptions[datesSections[indexPath.section]] else { return nil }
        let consumption = consumptionSection[indexPath.row]
        
        return ConsumptionTableViewCellViewModel(consumptionName: consumption.title, consumptionPrice: consumption.price)
    }
}
