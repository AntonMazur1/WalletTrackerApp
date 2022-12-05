//
//  ConsumptionTableViewCell.swift
//  WalletTrackerApp
//
//  Created by Клоун on 26.11.2022.
//

import UIKit

class ConsumptionTableViewCell: UITableViewCell {
    static let identifier = "ConsumptionCell"
    
    private let consumptionNameLabel = UILabel(text: "Name")
    private let consumptionPriceLabel = UILabel(text: "Price")
    
    var viewModel: ConsumptionTableViewCellViewModelProtocol! {
        didSet {
            consumptionNameLabel.text = viewModel.consumptionName
            consumptionPriceLabel.text = viewModel.consumptionPrice
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    private func setupConstraints() {
        setupViews(consumptionNameLabel, consumptionPriceLabel)
        
        NSLayoutConstraint.activate([
            consumptionNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            consumptionNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            consumptionPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            consumptionPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupViews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
