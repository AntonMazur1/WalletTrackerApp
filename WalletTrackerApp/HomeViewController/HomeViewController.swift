//
//  ViewController.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func add(consumption: ConsumptionTypeModel)
}

class HomeViewController: UIViewController, HomeViewControllerDelegate {
    weak var coordinator: CoordinatorProtocol?
    
    private let consumptionsTableView = UITableView()
    private let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    private let sortButton = UIButton(image: UIImage(systemName: "person.fill"))
    private let noItemsLabel = UILabel(text: "Нет затрат")
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = HomeViewModel()
        drawSegmentedCircle()
        
        noItemsLabel.isHidden = true
        
        setupNavigationBar()
        setupConstraints()
        setupSortButton()
        
        consumptionsTableView.round(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20)
        consumptionsTableView.delegate = self
        consumptionsTableView.dataSource = self
        consumptionsTableView.register(ConsumptionTableViewCell.self,
                                       forCellReuseIdentifier: ConsumptionTableViewCell.identifier)
    }
    
    func add(consumption: ConsumptionTypeModel) {
        viewModel.save(consumption: consumption) {
            consumptionsTableView.reloadData()
            drawSegmentedCircle()
        }
    }
    
    private func drawPieRim(_ slices: [(value: CGFloat, color: UIColor)],
                            at center: CGPoint,
                            radius: CGFloat,
                            thickness: CGFloat = 30) {
        let totalValues: CGFloat = slices.reduce(0) { $0 + $1.value }
        var angle = -CGFloat(Double.pi) / 2
        for (value, color) in slices {
            let path = UIBezierPath()
            let sliceAngle = CGFloat(Double.pi) * 2 * value / totalValues
            path.lineWidth = thickness
            color.setStroke()
            path.addArc(withCenter:center,
                        radius: radius,
                        startAngle: angle + sliceAngle,
                        endAngle: angle,
                        clockwise: false)
            path.stroke()
            angle += sliceAngle
        }
    }
    
    private func drawSegmentedCircle() {
        let slices: [(CGFloat, UIColor)] = viewModel.getNumberOfSegments().map { ($0, .random()) }
        view.backgroundColor = .black
        
        UIGraphicsBeginImageContextWithOptions(circleView.frame.size, false, 0)
        drawPieRim(slices, at: circleView.center, radius: 70)
        circleView.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        view.addSubview(circleView)
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addConsumption))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupSortButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.imagePadding = 5
        configuration.baseBackgroundColor = .clear
        sortButton.configuration = configuration
        sortButton.isUserInteractionEnabled = true
        sortButton.addTarget(self, action: #selector(sortConsumptionsByPrice), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        setupViews(consumptionsTableView, circleView, sortButton, noItemsLabel)
        
        NSLayoutConstraint.activate([
            consumptionsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            consumptionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            consumptionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            consumptionsTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            sortButton.bottomAnchor.constraint(equalTo: consumptionsTableView.topAnchor),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sortButton.widthAnchor.constraint(equalToConstant: 30),
            sortButton.heightAnchor.constraint(equalToConstant: 30),
            
            circleView.topAnchor.constraint(equalTo: view.topAnchor),
            circleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            circleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            circleView.bottomAnchor.constraint(equalTo: consumptionsTableView.topAnchor),
            
            noItemsLabel.centerXAnchor.constraint(equalTo: consumptionsTableView.centerXAnchor),
            noItemsLabel.centerYAnchor.constraint(equalTo: consumptionsTableView.centerYAnchor)
        ])
    }
    
    private func setupViews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    @objc func addConsumption() {
        let addConsumptionVC = AddConsumptionViewController()
        addConsumptionVC.delegate = self
        coordinator?.eventOccured(type: .buttonTapped, with: self)
    }
    
    @objc func sortConsumptionsByPrice() {
        viewModel.filterConsumptionsByPrice() {
            consumptionsTableView.reloadData()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows(at: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = viewModel.numberOfSections
        
        if numberOfSections == 0 {
            noItemsLabel.isHidden = false
        } else {
            noItemsLabel.isHidden = true
        }
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        var content = headerView.defaultContentConfiguration()
        content.text = viewModel.getTitleForHeader(at: section)
        content.textProperties.alignment = .center
        content.textProperties.color = .black
        headerView.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        " "
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = consumptionsTableView.dequeueReusableCell(withIdentifier: ConsumptionTableViewCell.identifier, for: indexPath) as! ConsumptionTableViewCell
        cell.viewModel = viewModel.getConsumptionCellViewModel(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        consumptionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteConsumption(at: indexPath)
            
            consumptionsTableView.numberOfRows(inSection: indexPath.section) > 1
            ? consumptionsTableView.deleteRows(at: [indexPath], with: .automatic)
            : consumptionsTableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            
            drawSegmentedCircle()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
