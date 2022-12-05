//
//  AddConsumptionViewController.swift
//  WalletTrackerApp
//
//  Created by Клоун on 25.11.2022.
//

import UIKit

class AddConsumptionViewController: UIViewController {
    weak var coordinator: CoordinatorProtocol?
    weak var delegate: HomeViewControllerDelegate?
    
    private let typePickerView = UIPickerView()
    
    private let doneButton = UIButton(title: "Сохранить", titleColor: .black)
    
    private let consumptionNameTextField = UITextField(placeholder: "Предмет расхода",
                                               borderStyle: .none,
                                               withBottomLine: true)
    private let consumptionTypeTextField = UITextField(placeholder: "Тип расхода",
                                               borderStyle: .none,
                                               withBottomLine: true)
    private let consumptionPriceTextField = UITextField(placeholder: "Цена",
                                                        borderStyle: .none,
                                                        keyboardType: .numberPad,
                                                        withBottomLine: true)
    
    private var viewModel: AddConsumptionViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.6863695979, green: 0.5352835059, blue: 1, alpha: 1)
        viewModel = AddConsumptionViewModel()
        setupPickerView()
        setupConstraints()
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        consumptionPriceTextField.delegate = self
    }
    
    private func setupConstraints() {
        let nameAndTypeOfConsumptionStackView = UIStackView(
            arrangedSubviews: [consumptionNameTextField, consumptionTypeTextField, consumptionPriceTextField],
            axis: .vertical,
            distributon: .fillProportionally,
            spacing: 30
        )
        
        setupView(with: nameAndTypeOfConsumptionStackView, doneButton)
        
        NSLayoutConstraint.activate([
            nameAndTypeOfConsumptionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameAndTypeOfConsumptionStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            nameAndTypeOfConsumptionStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
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
    
    private func showAlert(with title: String, and message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okeyAction)
        present(alertController, animated: true)
    }
    
    @objc func doneButtonPressed() {
        guard let consumptionName = consumptionNameTextField.text,
              let consumptionType = consumptionTypeTextField.text,
              let consumptionPrice = consumptionPriceTextField.text,
              !(consumptionName.isEmpty) && !(consumptionType.isEmpty) && !(consumptionPrice.isEmpty)
        else {
            showAlert(with: "Ошибка", and: "Заполните все необходимые поля")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let consumption = viewModel.saveConsumption(with: consumptionName,
                                                          type: consumptionType,
                                                          price: consumptionPrice,
                                                          and: dateFormatter.string(from: Date()))
        else { return }
        
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

//MARK: - UITextFieldDelegate
extension AddConsumptionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        guard allowedCharacters.isSuperset(of: characterSet) else {
            showAlert(with: "Ошибка", and: "Недопустимые символы в значении цены")
            return false
        }
        return true
    }
}
