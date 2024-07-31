//
//  ButtonView.swift
//  TvMovie
//
//  Created by 이수현 on 7/31/24.
//

import Foundation
import UIKit
import SnapKit


class ButtonView : UIView {
    
    let TVButton : UIButton = {
        let button = UIButton()
        button.setTitle("TV", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.configuration = UIButton.Configuration.bordered()
        
        return button
    }()
    
    let MovieButton : UIButton = {
        let button = UIButton()
        button.setTitle("Movie", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.configuration = UIButton.Configuration.bordered()
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    private func setUI(){
        addSubview(TVButton)
        addSubview(MovieButton)
        
        TVButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
        }
        
        MovieButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(TVButton.snp.trailing).offset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
