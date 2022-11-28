//
//  ViewController.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import UIKit

protocol HomeViewControllerDelegate {
    func add(consumption: ConsumptionTypeModel)
}

class HomeViewController: UIViewController, HomeViewControllerDelegate {
    private let consumptionsTableView = UITableView()
    
    private var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel = HomeViewModel()
        setupNavigationBar()
        setupConstraints()
        
        drawSegmentedCircle()
        
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
        let gapAngle = CGFloat(Double.pi) * 0.01
        var angle = -CGFloat(Double.pi) / 2
        for (value, color) in slices {
           let path = UIBezierPath()
           let sliceAngle = CGFloat(Double.pi) * 2 * value / totalValues
           path.lineWidth = thickness
           color.setStroke()
           path.addArc(withCenter:center,
                       radius: radius,
                       startAngle: angle + sliceAngle - gapAngle,
                       endAngle: angle,
                       clockwise: false)
           path.stroke()
           angle += sliceAngle
        }
    }
    
    private func drawSegmentedCircle() {
        var slices: [(CGFloat, UIColor)] = []
        
        let _ = viewModel.getNumberOfSegments().forEach {
            slices.append(($0, .random()))
        }
        
        let viewSize = CGSize(width: 300, height: 300)
        let circleView: UIView = UIView(frame: CGRect(origin: CGPointZero, size: viewSize))
        view.backgroundColor = .black

        UIGraphicsBeginImageContextWithOptions(viewSize, false, 0)

        drawPieRim(slices, at: CGPointMake(150,70), radius:50 )
        view.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()

        view.addSubview(circleView)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        consumptionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
    

