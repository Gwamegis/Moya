//
//  CustomModalViewController.swift
//  Halmap
//
//  Created by 전지민 on 2023/03/31.
//

import UIKit

class CustomModalViewController: UIViewController {
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
//    let maxDimmedAlpha: CGFloat = 0.6
//    lazy var dimmedView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.alpha = maxDimmedAlpha
//        return view
//    }()
    
    let defaultHeight: CGFloat = 300
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
//        view.addSubview(dimmedView)
        view.addSubview(containerView)
//        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
//            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
//            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // 6. Set container to default height
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        // 7. Set bottom constant to 0
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
//    func animatePresentContainer() {
//        UIView.animate(withDuration: 0.3) {
//            self.containerViewBottomConstraint?.constant = 0
//            self.view.layoutIfNeeded()
//        }
//    }
    
//    func animateShowDimmedView() {
//        dimmedView.alpha = 0
//        UIView.animate(withDuration: 0.4) {
//            self.dimmedView.alpha = self.maxDimmedAlpha
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        animateShowDimmedView()
//        animatePresentContainer()
    }
    
//    func animateDismissView() {
//        UIView.animate(withDuration: 0.3) {
//            self.containerViewBottomConstraint?.constant = self.defaultHeight
//            self.view.layoutIfNeeded()
//        }
//
//        dimmedView.alpha = maxDimmedAlpha
//        UIView.animate(withDuration: 0.4) {
//            self.dimmedView.alpha = 0
//        } completion: { _ in
//            self.dismiss(animated: false)
//        }
//    }
    
//    func setupPanGesture() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanAction(gesture:)))
//        
//        panGesture.delaysTouchesBegan = false
//        panGesture.delaysTouchesEnded = false
//        view.addGestureRecognizer(panGesture)
//    }
}

class CustomModalController2: UISheetPresentationController{
}
