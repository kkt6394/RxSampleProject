//
//  NumbersViewController.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/20/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NumbersViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = NumbersViewModel()
    
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    
    private let result = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureView()
//        rxTest()
        bind()
    }
    
    private func bind() {
        let input = NumbersViewModel.Input(
            num1: number1.rx.text.orEmpty,
            num2: number2.rx.text.orEmpty,
            num3: number3.rx.text.orEmpty
        )
        
        let output = viewModel.transform(input: input)
        
        output.result
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureHierarchy() {
        [number1, number2, number3, result]
            .forEach { view.addSubview($0) }
    }
    private func configureLayout() {
        number1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(80)
        }
        
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(80)
        }
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(80)
        }
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    private func configureView() {
        number1.borderStyle = .bezel
        number2.borderStyle = .bezel
        number3.borderStyle = .bezel
        
    }
    
    private func rxTest() {
            
        Observable.combineLatest(
            number1.rx.text.orEmpty,
            number2.rx.text.orEmpty,
            number3.rx.text.orEmpty) { value1, value2, value3 -> Int in
                return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
            }
        //        .map(\.description) //      \ -> KeyPath(키 경로), 특정 프로퍼티의 위치를 가리키는 역할.
        //        .map { $0.description }     // CustomStringConvertible 프로토콜을 채택한 객체
            .map { String($0) }           // String 인스턴스 새로 생성 -> String(1) 초기화
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
}
