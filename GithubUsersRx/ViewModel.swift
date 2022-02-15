//
//  ViewModel.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import RxSwift

class ViewModel {
    
    var cells = BehaviorSubject<[CellViewModel]>(value: [])
    
    private var bag = DisposeBag()
    
    private let endReachOffset: CGFloat = 100
    
    var nowFetchingUsers = false
    
    func onScroll(forTableView tableView: UITableView) {
        let offset = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let bottomOffset = contentHeight - tableView.frame.size.height - endReachOffset
        if offset > bottomOffset && !nowFetchingUsers {
            loadMoreUsers()
        }
    }
    
    private func loadMoreUsers() {
        let since = try! cells.value().last?.id
                
        nowFetchingUsers = true
        NetworkService.shared.fetchUsers(since: since )
            .map { $0.map { CellViewModel(forUser: $0)} }
            .subscribe { [weak self] vms in
                try? self?.cells.onNext((self?.cells.value())! + vms)
            } onCompleted: { [weak self] in
                self?.nowFetchingUsers = false
            }.disposed(by: bag)
    }
    
    func loadUsers() {
        nowFetchingUsers = true
        NetworkService.shared.fetchUsers(since: nil)
            .map { $0.map { CellViewModel(forUser: $0)} }
            .subscribe { [weak self] vms in
                self?.cells.onNext(vms)
            } onCompleted: { [weak self] in                
                self?.nowFetchingUsers = false
            }.disposed(by: bag)
    }
    
}
