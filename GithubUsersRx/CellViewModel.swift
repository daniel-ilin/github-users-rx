//
//  CellViewModel.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import RxSwift
import UIKit

class CellViewModel {
    
    private let imageLoader = ImageLoader()
    private(set) lazy var imageDownloadProgress = imageLoader.progress
    
    private(set) var username: String
    private(set) var id: String
    private var imageUrl: URL
    
    init(forUser user: User) {
        self.username = user.login
        self.id = String(user.id)
        self.imageUrl = URL(string: user.avatarURL)!
    }
    
    func downloadImage() -> Observable<UIImage> {
        return imageLoader.getImage(from: imageUrl)
    }

}
