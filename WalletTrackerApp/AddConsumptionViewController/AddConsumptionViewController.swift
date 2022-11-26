//
//  AddConsumptionViewController.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import UIKit

class AddConsumptionViewController: UIViewController {
    var delegate: HomeViewControllerDelegate?
    
    private let typePickerView = UIPickerView()
    
    private let consumptionNameTextField = UITextField(placeholder: "Предмет расхода",
                                               borderStyle: .none,
                                               withBottomLine: true)
    private let consumptionTypeTextField = UITextField(placeholder: "Тип расхода",
                                               borderStyle: .none,
                                               withBottomLine: true)
    
    private let pickTypeOfConsumptionButton = UIButton(image: UIImage(systemName: "calendar.circle.fill"))
    private let doneButton = UIButton(title: "Сохранить", titleColor: .black)
    
    private var viewModel: AddConsumptionViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = AddConsumptionViewModel()
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        setupPickerView()
        setupConstraints()
    }
    
    private func setupConstraints() {
        let typeAndPickerForConsumptionType = UIStackView(arrangedSubviews: [consumptionTypeTextField, pickTypeOfConsumptionButton],
                                                          axis: .horizontal,
                                                          spacing: 10)
        
        let nameAndTypeOfConsumptionStackView = UIStackView(arrangedSubviews: [consumptionNameTextField, typeAndPickerForConsumptionType],
                                                            axis: .vertical,
                                                            spacing: 30)
        
        setupView(with: nameAndTypeOfConsumptionStackView, doneButton)
        
        NSLayoutConstraint.activate([
            nameAndTypeOfConsumptionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameAndTypeOfConsumptionStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nameAndTypeOfConsumptionStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
    
    @objc func doneButtonPressed() {
        guard let consumptionName = consumptionNameTextField.text,
              let consumptionType = consumptionTypeTextField.text,
              !(consumptionName.isEmpty) && !(consumptionType.isEmpty)
        else { return }
        
        let consumption = viewModel.saveConsumption(with: consumptionName, type: consumptionType, and: Date())
        delegate?.add(consumption: consumption)
        dismiss(animated: true)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        consumptionTypeTextField.text = viewModel.getTitleForRow(at: row)
        consumptionTypeTextField.resignFirstResponder()
    }
}
