//
//  Coordinator.swift
//  WalletTrackerApp
//
//  Created by Клоун on 01.12.2022.
//

import UIKit

enum Event {
    case buttonTapped
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinator: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func eventOccured(type: Event, with delegate: HomeViewControllerDelegate?)
    func start()
}

class Coordinator: CoordinatorProtocol {
    var childCoordinator: [Coordinator] = []
    var navigationController = UINavigationController()
    
    func start() {
        let rootViewController = HomeViewController()
        rootViewController.coordinator = self
        navigationController.pushViewController(rootViewController, animated: true)
    }
    
    func eventOccured(type: Event, with delegate: HomeViewControllerDelegate? = nil) {
        switch type {
        case .buttonTapped:
            let addConsumptionVC = AddConsumptionViewController()
            addConsumptionVC.coordinator = self
            addConsumptionVC.delegate = delegate
            navigationController.present(addConsumptionVC, animated: true)
        }
    }
}
