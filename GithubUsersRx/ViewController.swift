//
//  ViewController.swift
//  GithubUsersRx
//
//  Created by Daniel Ilin on 2/6/22.
//

import RxSwift
import RxCocoa
import UIKit

class TableViewController: UITableViewController {
    
    private var viewModel = ViewModel()
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTableView()
        viewModel.loadUsers()
    }
    
    
    private func bindTableView() {
        tableView.dataSource = nil
        
        viewModel.cells
            .bind(to: tableView.rx.items(cellIdentifier: "cell",
                                         cellType: TableViewCell.self)) {
                index, vm, cell in
                cell.configureCell(from: vm)
            }.disposed(by: bag)

        
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.onScroll(forTableView: self.tableView)
        }.disposed(by: bag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

