//
//  TableViewCell.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import Foundation
import UIKit
import RxSwift

class TableViewCell: UITableViewCell {
    
    private var viewModel: CellViewModel?
    
    private var bag = DisposeBag()
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func prepareForReuse() {
        bag = DisposeBag()
        avatarImage.image = nil
    }
    
    func configureCell(from vm: CellViewModel) {
        viewModel = vm
        progressLabel.isHidden = false
        name.text = vm.username
        idLabel.text = vm.id
        
        downloadImage()
    }
    
    private func downloadImage() {
        viewModel?.downloadImage()
            .observe(on: MainScheduler())
            .subscribe(onNext: { [weak self] image in
                self?.progressLabel.isHidden = true
                self?.avatarImage.image = image
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
