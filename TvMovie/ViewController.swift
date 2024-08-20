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
    case horizontal(String)
    case vertical(String)
}

// 셀
enum Item : Hashable {
    case normal(Content)
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
        collectionView.register(BigImageCollectionViewCell.self, forCellWithReuseIdentifier: BigImageCollectionViewCell.id)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id)
        
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
            let items = tvList.map{Item.normal(Content(tv: $0))}
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.movieResult.bind { result in
            print(result)
            
            switch result {
            case .success(let movieResult):
                var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
                
                // nowPlaying
                let nowPlayingSection = Section.banner
                let nowPlayingItems = movieResult.nowPlaying.results.map{Item.bigImage($0)}
                snapshot.appendSections([nowPlayingSection])
                snapshot.appendItems(nowPlayingItems, toSection: nowPlayingSection)
                
                // popular
                let popularSection = Section.horizontal("Popular")
                let popularItems = movieResult.popular.results.map{Item.normal(Content(movie: $0))}
                snapshot.appendSections([popularSection])
                snapshot.appendItems(popularItems, toSection: popularSection)
                
                let upComingSection = Section.vertical("UpComing")
                let upComingItems = movieResult.upcoming.results.map{Item.list($0)}
                snapshot.appendSections([upComingSection])
                snapshot.appendItems(upComingItems, toSection: upComingSection)
                
                self.dataSource?.apply(snapshot)
            case .failure(let error) :
                print(error)
            }
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
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            switch section {
            case .double :
                return self?.createDoubleSection()
            case .banner :
                return self?.createBannerSection()
            case .horizontal :
                return self?.createHorizontalSection()
            case .vertical :
                return self?.createVerticalSection()
            default :
                return self?.createDoubleSection()
            }
            
        }, configuration: config)
    
    }
    
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        section.boundarySupplementaryItems.append(header)
        
        return section
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // 헤더 추가
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems.append(header)
        
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(640))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
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
             case .normal(let contentData) :
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: indexPath) as? NormalCollectionViewCell
                 cell?.config(imageURL: contentData.posterPath, title: contentData.title, review: contentData.vote, description: contentData.overview)
                 return cell
             case .bigImage(let movie):
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCollectionViewCell.id, for: indexPath) as? BigImageCollectionViewCell
                 cell?.config(title: movie.title, review: movie.vote, description: movie.overview, url: movie.posterPath)
                 return cell
             case .list(let movie):
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.id, for: indexPath) as? ListCollectionViewCell
                 cell?.config(title: movie.title, releaseDate: movie.releaseDate, url: movie.posterPath)
                 return cell
             }
        }
        
        // Section Header 설정
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            switch section {
            case .horizontal(let title) :
                (header as? HeaderView)?.config(title: title)
            case .vertical(let title) :
                (header as? HeaderView)?.config(title: title)
            default :
                print("not Header")
            }
            
            return header
        }
    }

}

// https://api.themoviedb.org/3/movie/550?api_key=a2b4f31ac5d507b646da97dd148418b2
