//
//  ReviewContentCollectionViewCell.swift
//  TvMovie
//
//  Created by 이수현 on 8/23/24.
//

import Foundation
import UIKit

class ReviewContentCollectionViewCell : UICollectionViewCell {
    static let id = "ReviewContentCollectionViewCell"
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(14)
        }
    }
    
    func confing(content : String) {
        contentLabel.text = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
