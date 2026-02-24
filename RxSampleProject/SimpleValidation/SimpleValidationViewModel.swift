//
//  SimpleValidationViewModel.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/24/26.
//

import Foundation
import RxSwift
import RxCocoa

final class SimpleValidationViewModel {
    private let disposeBag = DisposeBag()
    
    private let minimalUsernameLength = 5
    private let minimalPasswordLength = 5
    
    struct Input {
        let nameText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let actionTap: ControlEvent<Void>
    }
    
    struct Output {
        let isNameValid: Observable<Bool>
        let isPasswordValid: Observable<Bool>
        let isEverythingValid: Observable<Bool>
        let showAlert: PublishRelay<Void>

    }
    
    func transform(input: Input) -> Output {
        let isNameValid = input.nameText
            .map { $0.count >= self.minimalUsernameLength }
            .share(replay: 1)
        
        let isPasswordValid = input.passwordText
            .map { $0.count >= self.minimalPasswordLength }
            .share(replay: 1)
        
        let isEverythingValid = Observable.combineLatest(isNameValid, isPasswordValid) { $0 && $1 }
            .share(replay: 1)
        
        let showAlert = PublishRelay<Void>()
        
        input.actionTap
            .bind(to: showAlert)
            .disposed(by: disposeBag)
        
        return Output(
            isNameValid: isNameValid,
            isPasswordValid: isPasswordValid,
            isEverythingValid: isEverythingValid, showAlert: showAlert
        )
    }
    
}
