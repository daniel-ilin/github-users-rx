//
//  ViewModel.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import RxSwift

class ViewModel {
    
    func getCell() -> Observable<[CellViewModel]> {
        let users: Observable<Users> = NetworkService.shared.fetchUsers()
        return users.map { $0.map { CellViewModel(forUser: $0)} }
    }
    
}
