//
//  BigImageCollectionViewCell.swift
//  TvMovie
//
//  Created by 이수현 on 8/12/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class BigImageCollectionViewCell : UICollectionViewCell {
    static let id = "BigImageCollectionViewCell"
    
    let imageView = UIImageView()
    let stackView : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let reviewLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 3
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(reviewLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(500)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(14)
            make.trailing.bottom.equalToSuperview().offset(-14)
        }
    }
    
    func config(title : String, review : String, description : String, url : String){
        titleLabel.text = title
        reviewLabel.text = review
        descriptionLabel.text = description
        imageView.kf.setImage(with: URL(string: url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
