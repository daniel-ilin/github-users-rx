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
    private var isFetchingUsers = false
    
    func onScroll(offset: CGFloat, contentHeight: CGFloat, frameHeight: CGFloat) {
        let bottomOffset = contentHeight - frameHeight - endReachOffset
        if offset > bottomOffset && !isFetchingUsers {
            loadMoreUsers()
        }
    }
    
    func loadUsers() {
        fetchUsers(since: 0)
    }
    
    func loadMoreUsers() {
        // last.id only works because its plain list of users without any filters,
        // if you will do a search the ids not going to be the same as since
        guard let count = try? cells.value().count else {
            return
        }
        
        fetchUsers(since: count)
    }
    
    private func fetchUsers(since: Int) {
        if isFetchingUsers {
            return
        }
        
        // isFetchingUsers is not thread safe
        // here its changed on the main thread
        // and in onCompleted closure its on the dataTask thread
        // This may cause nasty race conditions
        // NOTE: Try running it with ThreadSanitizer option enabled in XCode
        isFetchingUsers = true
        
        NetworkService.shared.fetchUsers(since: since)
            .map { $0.map { CellViewModel(forUser: $0)} }
            .subscribe(onNext: { [weak self] vms in
                try? self?.cells.onNext((self?.cells.value())! + vms)
            }, onError: { [weak self] error in
                self?.isFetchingUsers = false  //You missed onError: what if error happens?
            }, onCompleted: { [weak self] in
                self?.isFetchingUsers = false
            })
            .disposed(by: bag)
    }
    
}
