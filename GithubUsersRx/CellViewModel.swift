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
    
    private(set) var username: String
    private(set) var id: String
    private(set) var imageUrl: URL
    
    
    init(forUser user: User) {
        self.username = user.login
        self.id = String(user.id)
        self.imageUrl = URL(string: user.avatarURL)!
    }        
    
    func getProgress() -> Observable<ImageDownloadObservable?> {
        return ImageLoader.shared.getDownloadProgress(from: imageUrl)
    }
    
}
