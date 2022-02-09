//
//  DefaultImages.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import UIKit

struct DefaultImages {
    
    static let shared = DefaultImages()
    
    var brokenImage: UIImage {
        UIImage(named: "userImage")!
    }
    
}
