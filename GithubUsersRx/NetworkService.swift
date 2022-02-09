//
//  NetworkService.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case badRequest
}

class NetworkService {
    
    static var shared = NetworkService()
    
    private let url = URL(string: "https://api.github.com/users")
    
    func fetchUsers<T: Decodable>()->Observable<T> {
        Observable.create { [weak self] observer in
            let dataTask = URLSession.shared.dataTask(with: (self?.url)!) { data, response, error in
                guard let data = data, let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                    observer.onError(NetworkError.badRequest)
                    return
                }
                observer.onNext(decoded)
                observer.onCompleted()
            }
            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
    
}
