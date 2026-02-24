//
//  SimpleTableViewModel.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/24/26.
//

import Foundation
import RxSwift
import RxCocoa

final class SimpleTableViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let tableViewTap: ControlEvent<String>
        let accTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let items: Observable<[String]>
        let showAlert: PublishRelay<String>
        let showAccAlert: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        let items = Observable.just((0..<20).map { "\($0)" })
        let showAlert = PublishRelay<String>()
        let showAccAlert = PublishRelay<String>()
        
        input.tableViewTap
            .bind(to: showAlert)
            .disposed(by: disposeBag)
        
        input.accTap
            .map { "\($0)"}
            .bind(to: showAccAlert)
            .disposed(by: disposeBag)
        
        return Output(items: items, showAlert: showAlert, showAccAlert: showAccAlert)
    }
    
    
}
