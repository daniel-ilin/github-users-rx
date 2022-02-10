//
//  ImageLoader.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import UIKit.UIImage
import RxSwift

class ImageCache {
    static let shared = Cache<URL, UIImage>()
}

class ImageLoader {
    
    private(set) var progress = PublishSubject<Double>()
    
    // cache should be shared accross all the instances
    private let cache = ImageCache.shared
    private var observation: NSKeyValueObservation?
    
    deinit {
        observation?.invalidate()
    }
        
    func getImage(from url: URL) -> Observable<UIImage>  {
        return Observable.create { [weak self] observer in
            
            if let cachedImage = self?.cache.value(forKey: url) {
                observer.onNext(cachedImage)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let datatask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    observer.onError(NetworkError.badRequest)
                    return
                }
                
                self?.cache.insert(image, forKey: url)
                
                observer.onNext(image)
                observer.onCompleted()
            }
            
            self?.observation = datatask.progress.observe(\.fractionCompleted) { progress, _ in
                self?.progress.onNext(progress.fractionCompleted)
            }
            
            datatask.resume()
            
            return Disposables.create {
                datatask.cancel()
            }
        }
    }
    
}
