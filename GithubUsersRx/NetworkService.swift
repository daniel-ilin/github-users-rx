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
    
    func fetchUsers(since: String?)->Observable<Users> {
        let since = since ?? "0"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users"
        components.queryItems = [
            URLQueryItem(name: "since", value: since),
            URLQueryItem(name: "per_page", value: "50")
        ]
        print("DEBUG: Fetching 50 users")
        guard let url = components.url else {
            return fetch(type: Users.self, url: URL(string: "https://api.github.com/users")!)
        }
        return fetch(type: Users.self, url: url)
    }
    
    private func fetch<T: Decodable>(type: T.Type, url: URL)->Observable<T> {
        Observable.create { observer in
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let decoded = try? JSONDecoder().decode(type, from: data) else {
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
