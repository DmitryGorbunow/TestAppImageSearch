//
//  NavBarController.swift
//  TestApp (Image Search)
//
//  Created by Dmitry Gorbunow on 11/24/22.
//

import UIKit

final class NavBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = .systemBackground
    }
    
    private func configure() {
        navigationBar.isTranslucent = true
    }
    
}
