//
//  ViewController.swift
//  TvMovie
//
//  Created by 이수현 on 7/29/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
    let buttonView = ButtonView()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI(){
        self.view.addSubview(buttonView)
        self.view.addSubview(collectionView)
        
        buttonView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonView.snp.bottom)
        }
        
        collectionView.backgroundColor = .blue
    }


}

// https://api.themoviedb.org/3/movie/550?api_key=a2b4f31ac5d507b646da97dd148418b2
