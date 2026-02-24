//
//  NumbersViewModel.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/24/26.
//

import Foundation
import RxSwift
import RxCocoa

final class NumbersViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let num1: ControlProperty<String>
        let num2: ControlProperty<String>
        let num3: ControlProperty<String>
    }
    
    struct Output {
        let result: BehaviorSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let result = BehaviorSubject(value: "0")
        
        Observable.combineLatest(
            input.num1,
            input.num2,
            input.num3
        ) { value1, value2, value3 -> Int in
            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
        }
        .map { String($0) }
        .bind { value in
            result.onNext(value)
        }
        .disposed(by: disposeBag)
        
        
        return Output(result: result)
    }
}
