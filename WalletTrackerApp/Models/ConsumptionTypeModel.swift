//
//  ConsumptionTypeModel.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import Foundation

struct ConsumptionTypeModel: Hashable, Equatable {
    let title: String
    let price: String
    let type: ConsumptionType
    let createDate: String
}
