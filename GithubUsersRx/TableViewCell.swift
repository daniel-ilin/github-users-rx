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
        
        checkProgress()
    }
    
    private func checkProgress() {
        viewModel?.getProgress()
            .observe(on: MainScheduler())
            .subscribe(onNext: { [weak self] imageObservable in
                if let image = imageObservable?.image {
                    self?.avatarImage.image = image
                    self?.progressLabel.isHidden = true
                } else {
                    imageObservable?.progress
                        .observe(on: MainScheduler())
                        .subscribe(onNext: { progress in                            
                            self?.progressLabel.text = String(progress ?? 0)
                        }).disposed(by: self!.bag)
                }
            }).disposed(by: bag)
    }
    
}
