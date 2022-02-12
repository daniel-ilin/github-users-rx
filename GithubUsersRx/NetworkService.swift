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
    
    private let usersURL = URL(string: "https://api.github.com/users")!
    
    // Expose controls and put default values rather then optional, makes the code more readable and usable
    func fetchUsers(since: Int = 0, perPage: Int = 50) -> Observable<Users> {
        var components = URLComponents(url: usersURL, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "since", value: String(since)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = components.url else {
            return fetch(type: Users.self, url: usersURL)
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
