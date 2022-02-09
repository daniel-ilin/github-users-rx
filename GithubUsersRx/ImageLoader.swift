//
//  ImageLoader.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import UIKit
import RxSwift


class ImageLoader {
    
    static var shared = ImageLoader()
    
    let cache = Cache<URL, UIImage>()
    
    func getDownloadProgress(from url: URL) -> Observable<ImageDownloadObservable?> {
        
        let key = url
        
        return Observable.create { [weak self] observer in
            
            let datatask = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                
                guard let data = data, let image = UIImage(data: data) else {
                    observer.onError(NetworkError.badRequest)
                    return
                }
                
                self?.cache.insert(image, forKey: key)
                print("DEBUG: Downloading")
                observer.onNext(ImageDownloadObservable(image: image, progress: Observable.of(1)))
                observer.onCompleted()
            }
            
            let progressObservable = datatask.progress.rx.observeWeakly(Double.self, "fractionCompleted")
            observer.onNext(ImageDownloadObservable(image: nil, progress: progressObservable))
            
            if let image = self?.cache.value(forKey: key) {
                print("DEBUG: From cache")
                observer.onNext(ImageDownloadObservable(image: image, progress: Observable.of(1)))
                observer.onCompleted()
            } else {
                datatask.resume()
            }
            
            return Disposables.create {
                datatask.cancel()
            }
        }
    }
    
}


struct ImageDownloadObservable {
    var image: UIImage?
    var progress: Observable<Double?>
}
