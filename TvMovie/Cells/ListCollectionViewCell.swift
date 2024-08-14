//
//  ListCollectionVIewCell.swift
//  TvMovie
//
//  Created by 이수현 on 8/12/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class ListCollectionViewCell : UICollectionViewCell {
    static let id = "ListCollectionVIewCell"
    
    let imageView : UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    let releaseLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(releaseLabel)
        
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(imageView.snp.width)

        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(8)
        }
        
        releaseLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        
    }
    
    func config(title : String, releaseDate : String, url : String){
        titleLabel.text = title
        releaseLabel.text = releaseDate
        imageView.kf.setImage(with: URL(string : url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
