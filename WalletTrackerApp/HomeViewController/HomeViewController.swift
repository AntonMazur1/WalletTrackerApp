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
    private let noItemsLabel = UILabel(text: "Добавьте затраты", isHidden: true)
    private let sortButton = UIButton(image: UIImage(systemName: "person.fill"))
    
    private var viewModel: HomeViewModelProtocol!
    private var dataSource: ConsumptionDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = HomeViewModel()
        
        setupDataSource()
        setupNavigationBar()
        setupConstraints()
        setupSortButton()
        
        drawSegmentedCircle()
        
        consumptionsTableView.round(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20)
        consumptionsTableView.register(ConsumptionTableViewCell.self,
                                       forCellReuseIdentifier: ConsumptionTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.update()
        noItemsLabel.isHidden = !dataSource.isEmptyConsumptionList()
    }
    
    func add(consumption: ConsumptionTypeModel) {
        dataSource.saveConsumption(consumption)
        noItemsLabel.isHidden = !dataSource.isEmptyConsumptionList()
        drawSegmentedCircle()
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
        let slices = dataSource.getCircleSegments()
        
        UIGraphicsBeginImageContextWithOptions(circleView.frame.size, false, 0)
        drawPieRim(slices, at: circleView.center, radius: 70)
        circleView.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        view.backgroundColor = .black
        view.addSubview(circleView)
    }
    
    private func setupDataSource() {
        dataSource = ConsumptionDataSource(tableView: consumptionsTableView) { [weak self] tableView, indexPath, consumption -> UITableViewCell? in
            let cell = self?.consumptionsTableView.dequeueReusableCell(withIdentifier: ConsumptionTableViewCell.identifier, for: indexPath) as! ConsumptionTableViewCell
            cell.viewModel = self?.dataSource.getConsumptionCellViewModel(with: consumption)
            return cell
        }
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addConsumptionPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupSortButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.imagePadding = 5
        configuration.baseBackgroundColor = .clear
        
        sortButton.configuration = configuration
        sortButton.isUserInteractionEnabled = true
        sortButton.addTarget(self, action: #selector(sortConsumptionsByPricePressed), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        setupViews(consumptionsTableView, circleView, noItemsLabel, sortButton)
        
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
    
    @objc func addConsumptionPressed() {
        let addConsumptionVC = AddConsumptionViewController()
        addConsumptionVC.delegate = self
        coordinator?.eventOccured(type: .buttonTapped, with: self)
    }
    
    @objc func sortConsumptionsByPricePressed() {
//        viewModel.filterConsumptionsByPrice() {
//            consumptionsTableView.reloadData()
//        }
    }
}
