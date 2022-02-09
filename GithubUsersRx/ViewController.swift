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
        
        configureTableView()
    }

    
    private func configureTableView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshTable))
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
    
    @objc func refreshTable() {
        tableView.dataSource = nil
        viewModel.getCell()
            .bind(to: tableView.rx.items(cellIdentifier: "cell",
                                         cellType: TableViewCell.self)) {
                index, vm, cell in
                cell.configureCell(from: vm)
            }.disposed(by: bag)
    }

}

