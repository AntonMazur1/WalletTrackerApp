//
//  HomeViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    var numberOfSections: Int { get }
    func getNumberOfSegments() -> [CGFloat]
    func getNumberOfRows(at section: Int) -> Int
    func save(consumption: ConsumptionTypeModel, completion: () -> ())
    func getConsumptionCellViewModel(at indexPath: IndexPath) -> ConsumptionTableViewCellViewModelProtocol?
}

class HomeViewModel: HomeViewModelProtocol {
    private var consumptions: [Date: [ConsumptionTypeModel]] = [:]
    
    var numberOfSections: Int {
        consumptions.keys.count
    }
    
    func save(consumption: ConsumptionTypeModel, completion: () -> ()) {
        guard consumptions[consumption.createDate] == nil else {
            consumptions[consumption.createDate]?.append(consumption)
            return
        }
        
        consumptions[consumption.createDate] = [consumption]
        completion()
    }
    
    func getNumberOfSegments() -> [CGFloat] {
        var numberOfSegments: [CGFloat] = []
        
        consumptions.keys.forEach {
            numberOfSegments.append(CGFloat(consumptions[$0]?.count ?? 0))
        }
        
        return numberOfSegments
    }
    
    func getNumberOfRows(at section: Int) -> Int {
        let datesSections = Array(consumptions.keys)
        guard let numberOfRows = consumptions[datesSections[section]]?.count else { return 0 }
        
        return numberOfRows
    }
    
    func getTitleForHeader(at section: Int) -> String {
        let itemsInSections = Array(consumptions.values)
        guard let createDateHeader = itemsInSections[section].first else { return "" }
        
        return createDateHeader.createDate.description
    }
    
    func getConsumptionCellViewModel(at indexPath: IndexPath) -> ConsumptionTableViewCellViewModelProtocol? {
        let datesSections = Array(consumptions.keys)
        guard let consumptionSection = consumptions[datesSections[indexPath.section]] else { return nil }
        let consumption = consumptionSection[indexPath.row]
        
        return ConsumptionTableViewCellViewModel(consumptionName: consumption.title)
    }
}
