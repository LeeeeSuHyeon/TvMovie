//
//  ViewController.swift
//  TvMovie
//
//  Created by 이수현 on 7/29/24.
//

import UIKit
import SnapKit
import RxSwift

// 레이아웃
enum Section : Hashable {
    case double 
    case banner
    case horizontal
    case vertical
}

// 셀
enum Item : Hashable {
    case normal(TV)
    case bigImage(Movie)
    case list(Movie)
    
}

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let buttonView = ButtonView()
    private var dataSource : UICollectionViewDiffableDataSource<Section, Item>?
    
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(NormalCollectionViewCell.self, forCellWithReuseIdentifier: NormalCollectionViewCell.id)
        
        return collectionView
    }()
    
    let viewModel = ViewModel()
    let tvTrigger = PublishSubject<Void>()
    let movieTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDatasource()
        bindViewModel()
        bindView()
        tvTrigger.onNext(())
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
    }

    private func bindViewModel(){
        let input = ViewModel.Input(tvTrigger: tvTrigger, MovieTrigger: movieTrigger)
        let output = viewModel.transform(input: input)
        
        // disposeBag : ViewController가 사라질 때 바인딩도 함께 제거
        // viewModel의 ouput 리턴 값을 바인딩
        output.tvList.bind {[weak self] tvList in
            print(tvList)
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            let items = tvList.map{Item.normal($0)}
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.movieResult.bind { movieResult in
            print(movieResult)
        }.disposed(by : disposeBag)
    }
    
    private func bindView(){
        // TV 버튼 눌렀을 때, tvTrigger에 Void 전달
        buttonView.TVButton.rx.tap.bind { [weak self] in
            self?.tvTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        buttonView.MovieButton.rx.tap.bind { [weak self] in 
            self?.movieTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }
    
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14
        
        return UICollectionViewCompositionalLayout(sectionProvider: {[weak self] sectionIndex, _ in
            return self?.createDoubleSection()
        }, configuration: config)
    
    }
    
    private func createDoubleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func setDatasource() {
         dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
             switch item {
             case .normal(let tvData) :
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: indexPath) as? NormalCollectionViewCell
                 cell?.config(imageURL: tvData.posterURL, title: tvData.name, review: tvData.vote, description: tvData.overview)
                 return cell
             case .bigImage(_):
                 <#code#>
             case .list(_):
                 <#code#>
             }
        }
    }

}

// https://api.themoviedb.org/3/movie/550?api_key=a2b4f31ac5d507b646da97dd148418b2
