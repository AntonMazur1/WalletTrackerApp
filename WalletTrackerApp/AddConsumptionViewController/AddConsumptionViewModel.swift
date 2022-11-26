//
//  AddConsumptionViewModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import Foundation

enum ConsumptionType: String, CaseIterable {
    case travell = "Travell"
    case shopping = "Shopping"
    case rent = "Rent"
    case grocery = "Groceries"
}

protocol AddConsumptionViewModelProtocol {
    var numberOfTypes: Int { get }
    func getTitleForRow(at row: Int) -> String?
    func saveConsumption(with title: String, type: String, and date: Date) -> ConsumptionTypeModel?
}

class AddConsumptionViewModel: AddConsumptionViewModelProtocol {
    private let typesOfConsumption = ConsumptionType.allCases
    
    var numberOfTypes: Int {
        typesOfConsumption.count
    }
    
    func getTitleForRow(at row: Int) -> String? {
        typesOfConsumption[row].rawValue
    }
    
    func saveConsumption(with title: String, type: String, and date: Date) -> ConsumptionTypeModel? {
        guard let type = ConsumptionType(rawValue: type) else { return nil }
        return ConsumptionTypeModel(title: title, type: type, createDate: date)
    }
}
