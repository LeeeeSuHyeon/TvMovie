//
//  ReviewHeaderCollectionViewCell.swift
//  TvMovie
//
//  Created by 이수현 on 8/23/24.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit

class ReviewHeaderCollectionViewCell : UICollectionViewCell {
    static let id = "ReviewHeaderCollectionViewCell"
    
    let imageView : UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        
        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    func config(title : String, url : String){
        if url.isEmpty {
            imageView.image = UIImage(systemName: "person.fill")
        }
        else {
            imageView.kf.setImage(with: URL(string: url))
        }
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
