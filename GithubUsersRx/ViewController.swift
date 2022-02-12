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
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)) { index, vm, cell in
                cell.configureCell(from: vm)
            }.disposed(by: bag)

        
        // - "unowned self" should be fine here since no scroll event should be called if the tableview dissapears
        // - don't pass UI objects to viewModel, it shouldn't work with UI directly (its not its responsability)
        tableView.rx.didScroll.subscribe { [unowned self] _ in
            self.viewModel.onScroll(
                offset: self.tableView.contentOffset.y,
                contentHeight: self.tableView.contentSize.height,
                frameHeight: self.tableView.frame.size.height
            )
        }.disposed(by: bag)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

