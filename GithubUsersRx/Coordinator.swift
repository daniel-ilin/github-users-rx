//
//  Coordinator.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/12/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
