//
//  ReviewViewController.swift
//  TvMovie
//
//  Created by 이수현 on 8/21/24.
//

import Foundation
import UIKit
import RxSwift

fileprivate enum Section {
    case list
}

fileprivate enum Item {
    case header(ReviewHeader)
    case content(String)
}

fileprivate struct ReviewHeader {
    let id : String
    let name : String
    let URL : String
}


class ReviewViewController : UIViewController {
    let reviewViewModel : ReviewViewModel
    let disposeBag = DisposeBag()
    let collectionView : UICollectionView = {
        let confing = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: confing)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ReviewHeaderCollectionViewCell.self, forCellWithReuseIdentifier: ReviewHeaderCollectionViewCell.id)
        return collectionView
    }()
    
    init(id : Int, contentType : ContentType){
        self.reviewViewModel = ReviewViewModel(id: id, contentType: contentType)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setUI()
    }
    
    func setUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bindViewModel(){
        let output = reviewViewModel.transform(input: ReviewViewModel.Input())
        output.reviewResult.bind { result in
            switch result {
            case .success(let reviewList) :
                print(reviewList)
            case .failure(let error) :
                print(error)
                
            }
            
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
