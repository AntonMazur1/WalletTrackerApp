//
//  ViewController.swift
//  WalletTrackerApp
//
//  Created by Клоун on 24.11.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let viewSize = CGSize(width: 300, height: 300)
        let viewCircle = UIView(frame: CGRect(origin: CGPointZero, size: viewSize))
        view.backgroundColor = .white
        
        UIGraphicsBeginImageContextWithOptions(viewSize, false, 0)
        
        drawSegmentedCircle([(3, UIColor.yellow),
                             (6, UIColor.green)],
                            at: CGPointMake(150, 150),
                            radius: 100)
        view.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        view.addSubview(viewCircle)
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    private func drawSegmentedCircle(_ slices:[(value: CGFloat, color: UIColor)],
                    at center: CGPoint,
                    radius: CGFloat,
                    width: CGFloat = 20) {
        
        let totalValues:CGFloat = slices.reduce(0) { $0 + $1.value }
        var angle = -CGFloat(Double.pi) / 2
        
        for (value, color) in slices {
            let path = UIBezierPath()
            let sliceAngle = CGFloat(Double.pi) * 2 * value / totalValues
            path.lineWidth = width
            
            color.setStroke()
            
            path.addArc(withCenter:center,
                        radius: radius,
                        startAngle: angle + sliceAngle,
                        endAngle: angle,
                        clockwise: false)
            path.stroke()
            
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.lineWidth = 3
//            shapeLayer.path = path.cgPath
//            shapeLayer.fillColor = UIColor.red.cgColor
//            shapeLayer.strokeColor = UIColor.yellow.cgColor
//            view.layer.addSublayer(shapeLayer)
            angle += sliceAngle
        }
    }
    
    @objc func addTask() {
        let addConsumptionVC = AddConsumptionViewController()
        present(addConsumptionVC, animated: true)
    }
}

