//
//  Extension + Dictionary.swift
//  WalletTrackerApp
//
//  Created by Клоун on 08.12.2022.
//

import Foundation

extension Dictionary where Value: Equatable {
    func getKey(for value: Value) -> Key? {
        first(where: { $1 == value })?.key
    }
}
