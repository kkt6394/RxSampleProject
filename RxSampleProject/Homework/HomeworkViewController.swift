//
//  HomeworkViewController.swift
//  SeSACRxThreads
//
//  Created by Jack on 2/23/26.
//

import UIKit
//import Alamofire
import SnapKit
import RxSwift
import RxCocoa

final class HomeworkViewController: UIViewController {
    
    private let tableView = UITableView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let searchBar = UISearchBar()
    
    private let viewModel = HomeworkViewModel()
    private let disposeBag = DisposeBag()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        let input = HomeworkViewModel.Input(
            tableViewTapped: tableView.rx.modelSelected(SampleUser.self), searchBarText: searchBar.rx.text.orEmpty,
            searchBarReturn: searchBar.rx.searchButtonClicked
        )
        let output = viewModel.transform(input: input)
        
        output.users
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier) as? PersonTableViewCell else { return  UITableViewCell() }
                cell.configureCell(name: element.name)
                cell.detailButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vc = EmptyViewController()
                        owner.navigationController?.pushViewController(vc, animated: true)
                        vc.navigationItem.title = element.name
                    }
                    .disposed(by: cell.disposeBag)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.selectedUsers
            .bind(to: collectionView.rx.items(cellIdentifier: UserCollectionViewCell.identifier, cellType: UserCollectionViewCell.self)) { (row, element, cell) in
                cell.configureCell(text: element.name)
            }
            .disposed(by: disposeBag)
        
        output.clearSearchBar
            .bind(with: self) { owner, _ in
                owner.searchBar.text = ""
                owner.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
    
    }
    
    private func configure() {
        
        tableView.backgroundColor = .blue
        collectionView.backgroundColor = .lightGray

        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
         
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }

}



