//
//  ReviewViewController.swift
//  TvMovie
//
//  Created by 이수현 on 8/21/24.
//

import Foundation
import UIKit
import RxSwift

fileprivate enum Section : Hashable{
    case list
}

fileprivate enum Item : Hashable{
    case header(ReviewHeader)
    case content(String)
}

fileprivate struct ReviewHeader : Hashable {
    let id : String
    let name : String
    let URL : String
}


class ReviewViewController : UIViewController {
    let reviewViewModel : ReviewViewModel
    let disposeBag = DisposeBag()
    private var dataSource : UICollectionViewDiffableDataSource<Section, Item>?
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
        
        setDataSource()
        
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        dataSourceSnapshot.appendSections([.list])
        dataSource?.apply(dataSourceSnapshot)
    }
    
    func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .header(let header) :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewHeaderCollectionViewCell.id, for: indexPath) as? ReviewHeaderCollectionViewCell
                cell?.config(title: header.name, url: header.URL)
                return cell
            case .content(let content) :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewHeaderCollectionViewCell.id, for: indexPath) as? ReviewHeaderCollectionViewCell
                return cell
            }
        })
    }
    
    func bindViewModel(){
        let output = reviewViewModel.transform(input: ReviewViewModel.Input())
        output.reviewResult.map { result -> [ReviewModel] in
            switch result {
            case .success(let reviewList) :
                print(reviewList)
                return reviewList
            case .failure(let error) :
                print(error)
                return []
                
            }
            
        }.bind { [weak self] reviewList in
            guard !reviewList.isEmpty else { return }
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            reviewList.forEach { review in
                let header = ReviewHeader(id: review.id,
                                          name: review.author.name.isEmpty ? review.author.username : review.author.name, URL: review.author.imagePath)
                let headerItem = Item.header(header)
                sectionSnapshot.append([headerItem])
            }
            self?.dataSource?.apply(sectionSnapshot, to: .list)
        }
        .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
