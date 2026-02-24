//
//  HomeworkViewModel.swift
//  HomeWorkRx
//
//  Created by 김기태 on 2/23/26.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeworkViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: BehaviorSubject<Void>
        let tableViewTapped: ControlEvent<SampleUser>
        let searchBarText: ControlProperty<String>
        let searchBarReturn: ControlEvent<Void>
    }
    
    struct Output {
        let users: BehaviorSubject<[SampleUser]>
        let selectedUsers: BehaviorSubject<[SampleUser]>
        let clearSearchBar: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let users = BehaviorSubject<[SampleUser]>(value: dummyUsers)
        let selectedUsers = BehaviorSubject<[SampleUser]>(value: [])
        let clearSearchBar = PublishRelay<Void>()
        
        input.tableViewTapped
            .withLatestFrom(selectedUsers) { newUser, currentUser in
                var updatedUsers = currentUser
                updatedUsers.append(newUser)
                return updatedUsers
            }
            .bind(to: selectedUsers)
            .disposed(by: disposeBag)
        
        input.searchBarReturn
            .withLatestFrom(input.searchBarText)
            .withLatestFrom(users) { text, currentUser in
                let newUser = SampleUser(name: text, age: 0)
                var updatedUsers = currentUser
                updatedUsers.append(newUser)
                return updatedUsers
            }
            .bind(to: users)
            .disposed(by: disposeBag)
        
        input.searchBarReturn
            .bind { _ in
                clearSearchBar.accept(())
            }
            .disposed(by: disposeBag)
        
        
        
                
        return Output(users: users, selectedUsers: selectedUsers, clearSearchBar: clearSearchBar)
    }
    
    
}
