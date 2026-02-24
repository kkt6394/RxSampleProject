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
        let viewDidLoad = BehaviorSubject<Void>(value: ())
        let tableViewTapped = PublishSubject<SampleUser>()
        let searchBarReturn = PublishSubject<String>()
    }
    struct Output {
        let users: BehaviorSubject<[SampleUser]>
        let selectedUsers: Observable<[SampleUser]>
    }
    
    func transform(input: Input) -> Output {
        let users = makeUserList(event: input.viewDidLoad)
        let selectedUsers = makeSelectedUserList(event: input.tableViewTapped)
        
        input.searchBarReturn
            .map { SampleUser.init(name: $0, age: 0)}
            .withLatestFrom(users) { newUser, currentUsers in
                var newList = currentUsers
                newList.append(newUser)
                return newList
            }
            .bind(to: users)
            .disposed(by: disposeBag)
        
        return Output(users: users, selectedUsers: selectedUsers)
    }
    
    func makeUserList(event: BehaviorSubject<Void>) -> BehaviorSubject<[SampleUser]> {
        let userSubject = BehaviorSubject<[SampleUser]>(value: dummyUsers)
        
        event
            .map { _ in dummyUsers }
            .bind(to: userSubject)
            .disposed(by: disposeBag)
        
        return userSubject
    }
    
    func makeSelectedUserList(event: PublishSubject<SampleUser>) -> Observable<[SampleUser]> {
        return event
            .scan(into: [SampleUser]()) { array, user in
                array.append(user)
            }
    }
    
    
    
}
