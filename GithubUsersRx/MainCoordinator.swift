//
//  MainCoordinator.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/12/22.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinator = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController        
    }
    
    func start() {
        let vc = TableViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showCollectionView() {
        let vc = CollectionViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
