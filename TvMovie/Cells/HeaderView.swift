//
//  HeaderView.swift
//  TvMovie
//
//  Created by 이수현 on 8/12/24.
//

import Foundation
import UIKit
import SnapKit


class HeaderView : UICollectionReusableView {
    static let id = "HeaderView"
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
    }
    
    func config(title : String){
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
