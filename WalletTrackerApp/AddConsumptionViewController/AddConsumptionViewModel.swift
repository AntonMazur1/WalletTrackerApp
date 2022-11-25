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
}

class AddConsumptionViewModel: AddConsumptionViewModelProtocol {
    private let typesOfConsumption = ConsumptionType.allCases
    
    var numberOfTypes: Int {
        typesOfConsumption.count
    }
    
    func getTitleForRow(at row: Int) -> String? {
        typesOfConsumption[row].rawValue
    }
}
