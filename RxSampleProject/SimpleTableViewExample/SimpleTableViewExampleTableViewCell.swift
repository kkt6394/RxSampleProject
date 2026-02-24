//
//  SimpleTableViewExampleTableViewCell.swift
//  RxSampleProject
//
//  Created by 김기태 on 2/20/26.
//

import UIKit
import SnapKit

final class SimpleTableViewExampleTableViewCell: UITableViewCell {
    let numlabel = UILabel()
//    let image = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [numlabel/*, image*/].forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        numlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
//        image.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(10)
//            make.centerY.equalToSuperview()
//        }
        
    }
    
    private func configureView() {
        
        numlabel.textColor = UIColor.black
        
//        image.image = UIImage(systemName: "info.circle")
    }
}
