//
//  CollectionViewCell.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/13/22.
//

import UIKit
import RxSwift

class CollectionViewCell: UICollectionViewCell {
    
    private var viewModel: CellViewModel?
    private var bag = DisposeBag()
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func prepareForReuse() {
        bag = DisposeBag()
        imageView.image = nil
    }
    
    func configure(with vm: CellViewModel) {
        self.viewModel = vm
        nameLabel.text = viewModel!.username
        downloadImage()
    }
        
    private func downloadImage() {
        viewModel?.downloadImage()
            .observe(on: MainScheduler())
            .subscribe(onNext: { [weak self] image in
                self?.progressLabel.isHidden = true
                self?.imageView.image = image
            })
            .disposed(by: bag)
        
        
        viewModel?.imageDownloadProgress
            .observe(on: MainScheduler())
            .subscribe(onNext: { [weak self] progress in
                self?.progressLabel.text = String(describing: progress)
            })
            .disposed(by: bag)
            
    }
}
