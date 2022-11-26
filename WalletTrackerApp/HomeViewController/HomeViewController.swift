//
//  ViewController.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import UIKit

protocol HomeViewControllerDelegate {
    func add(consumption: ConsumptionTypeModel?)
}

class HomeViewController: UIViewController, HomeViewControllerDelegate {
    private let consumptionsTableView = UITableView()
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = HomeViewModel()
        consumptionsTableView.delegate = self
        consumptionsTableView.dataSource = self
        setupNavigationBar()
        setupConstraints()
        consumptionsTableView.register(ConsumptionTableViewCell.self,
                                       forCellReuseIdentifier: ConsumptionTableViewCell.identifier)
    }
    
    func add(consumption: ConsumptionTypeModel?) {
        //логика для добавления в TableView
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupConstraints() {
        setupViews(consumptionsTableView)
        
        NSLayoutConstraint.activate([
            consumptionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            consumptionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            consumptionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            consumptionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupViews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    @objc func addTask() {
        let addConsumptionVC = AddConsumptionViewController()
        addConsumptionVC.delegate = self
        present(addConsumptionVC, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.getTitleForHeader(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = consumptionsTableView.dequeueReusableCell(withIdentifier: ConsumptionTableViewCell.identifier, for: indexPath) as! ConsumptionTableViewCell
        cell.viewModel = viewModel.getConsumptionCellViewModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
    

