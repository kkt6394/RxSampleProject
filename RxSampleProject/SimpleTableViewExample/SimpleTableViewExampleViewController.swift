//
//  SimpleTableViewExampleViewController.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/20/26.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewExampleViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        rxTest()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.register(SimpleTableViewExampleTableViewCell.self, forCellReuseIdentifier: String(describing: SimpleTableViewExampleTableViewCell.self))
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func rxTest() {
        let items = Observable.just(
            (0..<20).map { "\($0)"}
        )
        items
            .bind(to: tableView.rx
                .items(cellIdentifier: String(describing: SimpleTableViewExampleTableViewCell.self), cellType: SimpleTableViewExampleTableViewCell.self)) { row, element, cell in
                    cell.numlabel.text = "item element: \(element), row: \(row)"
                    cell.accessoryType = .detailButton
                }
                .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind { [weak self] string in
                guard let self = self else { return }
                self.presentAlert(string)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                self.presentAlert("indexPath: \(indexPath)")
            }
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(_ message: String) {
        let alert = UIAlertController(
            title: "RxExample",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
                        
        
        
    }
    
    
}

