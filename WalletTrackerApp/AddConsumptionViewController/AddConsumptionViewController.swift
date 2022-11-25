//
//  AddConsumptionViewController.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import UIKit

class AddConsumptionViewController: UIViewController {
    
    private let consumptionNameTextField = UITextField(placeholder: "Предмет расхода",
                                               borderStyle: .none,
                                               withBottomLine: true)
    private let consumptionTypeTextField = UITextField(placeholder: "Тип расхода",
                                               borderStyle: .none,
                                               withBottomLine: true)
    
    private let pickTypeOfConsumptionButton = UIButton(image: UIImage(systemName: "calendar.circle.fill")!)
    
    private let typePickerView = UIPickerView()
    
    private var viewModel: AddConsumptionViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = AddConsumptionViewModel()
        setupConstraints()
    }
    
    private func setupConstraints() {
        let typeAndPickerForConsumptionType = UIStackView(arrangedSubviews: [consumptionTypeTextField, pickTypeOfConsumptionButton],
                                                          axis: .horizontal,
                                                          spacing: 10)
        
        let nameAndTypeOfConsumptionStackView = UIStackView(arrangedSubviews: [consumptionNameTextField, typeAndPickerForConsumptionType],
                                                            axis: .vertical,
                                                            spacing: 30)
        
        setupView(with: nameAndTypeOfConsumptionStackView)
        
        NSLayoutConstraint.activate([
            nameAndTypeOfConsumptionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameAndTypeOfConsumptionStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameAndTypeOfConsumptionStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupView(with views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupPickerView() {
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        consumptionTypeTextField.inputView = typePickerView
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddConsumptionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfTypes
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.getTitleForRow(at: row)
    }
}
