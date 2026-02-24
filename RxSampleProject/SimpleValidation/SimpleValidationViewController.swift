//
//  SimpleValidationViewController.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/20/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

final class SimpleValidationViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SimpleValidationViewModel()
    
    private let userNameLabel = UILabel()
    private let userNameTF = UITextField()
    private let userNameValidateLabel = UILabel()
    
    private let passwordLabel = UILabel()
    private let passwordTF = UITextField()
    private let passwordValidateLabel = UILabel()
    
    private let actionButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        
        userNameValidateLabel.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidateLabel.text = "Password has to be at least \(minimalPasswordLength) characters"
        //        rxTest()
        bind()
    }
    
    private func configureHierarchy() {
        [
            userNameLabel,
            userNameTF,
            userNameValidateLabel,
            passwordLabel,
            passwordTF,
            passwordValidateLabel,
            actionButton
        ].forEach { view.addSubview($0) }
    }
    
    private func configureLayout() {
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        userNameTF.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(44)
        }
        
        userNameValidateLabel.snp.makeConstraints {
            $0.top.equalTo(userNameTF.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(userNameValidateLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        passwordTF.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(44)
        }
        
        passwordValidateLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTF.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(passwordValidateLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        // Username
        userNameLabel.text = "Username"
        userNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        userNameTF.borderStyle = .roundedRect
        userNameTF.placeholder = "Enter username"
        
        userNameValidateLabel.textColor = .red
        userNameValidateLabel.font = .systemFont(ofSize: 12)
        
        // Password
        passwordLabel.text = "Password"
        passwordLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        passwordTF.borderStyle = .roundedRect
        passwordTF.placeholder = "Enter password"
        passwordTF.isSecureTextEntry = true
        
        passwordValidateLabel.textColor = .red
        passwordValidateLabel.font = .systemFont(ofSize: 12)
        
        // Button
        actionButton.setTitle("Do something", for: .normal)
        actionButton.setTitleColor(.black, for: .normal)
        //        actionButton.backgroundColor = .systemGreen
        actionButton.layer.cornerRadius = 8
        actionButton.isEnabled = false
        
    }
    
    private func bind() {
        let input = SimpleValidationViewModel.Input(
            nameText: userNameTF.rx.text.orEmpty,
            passwordText: passwordTF.rx.text.orEmpty, actionTap: actionButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.isNameValid
            .bind(to: passwordLabel.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isNameValid
            .bind(to: userNameValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isPasswordValid
            .bind(to: passwordValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isEverythingValid
            .bind(with: self) { owner, value in
                owner.actionButton.backgroundColor = value ? .green : .red
                owner.actionButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        output.showAlert
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func rxTest() {
        let usernameValid = userNameTF.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordTF.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: passwordLabel.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: userNameValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        everythingValid
            .bind(with: self) { owner, bool in
                owner.actionButton.backgroundColor = bool ? .green : .red
                owner.actionButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        
        actionButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        )
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
