//
//  ViewModel.swift
//  TvMovie
//
//  Created by 이수현 on 8/1/24.
//

import Foundation
import RxSwift

class ViewModel {
    let disposeBag = DisposeBag()
    private let tvNetwork : TVNetwork
    private let movieNetwork : MovieNetwork
    var contentType : ContentType = .tv
    var currentTVList : [TV] = []
    
    init(){
        let provider = NetworkProvider()
        tvNetwork = provider.makeTVNetwork()
        movieNetwork = provider.makeMovieNetwork()
    }
    
    struct Input {
        let query : Observable<String>
        let tvTrigger : Observable<Int>
        let MovieTrigger : Observable<Void>
    }
    
    struct Output {
        let tvList : Observable<[TV]>
        let movieResult : Observable<Result<MovieResult,Error>>
    }
    
    func transform(input : Input) -> Output {
        let tvList = Observable.combineLatest(input.query, input.tvTrigger)
            .flatMapLatest {  [unowned self] query, page in
                if page == 1 { currentTVList = [] }
                contentType = .tv
                
                if query.isEmpty {
                    return self.tvNetwork.getTopRatedList(page: page)
                } else {
                    return self.tvNetwork.getQueriedList(page: page, query: query)
                }
            }
            .map{$0.results}
            .map { tvList in
                // 현재 리스트 + 새로 받아온 리스트
                self.currentTVList += tvList
                return self.currentTVList
            }
        
        // trigger -> network -> Observable<T> -> VC 전달 -> VC 구독
//        let tvList = input.tvTrigger.flatMapLatest { [unowned self] page -> Observable<[TV]> in
//            if page == 1 {
//                currentTVList = []
//            }
//            contentType = .tv
//            // tvTrigger -> Observable<Void> -> Observable<TV>
//            return self.tvNetwork.getTopRatedList(page: page).map{$0.results}.map { tvList in
//                // 현재 리스트 + 새로 받아온 리스트
//                self.currentTVList += tvList
//                return self.currentTVList
//            }
//        }
        
        let movieResult = input.MovieTrigger.flatMapLatest { [unowned self] _ -> Observable<Result<MovieResult,Error>> in
            contentType = .movie
            
            // 여러 개의 Observable을 합칠 때는 combineLatest를 사용
            return Observable.combineLatest(movieNetwork.getUpcoming(), movieNetwork.getPopular(), 
                                            movieNetwork.getNowPlaying()){ upcoming, popular, nowPlaying -> Result<MovieResult,Error> in
                
                .success(MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowPlaying))
            }.catchError{ error in
                print(error)
                return Observable.just(.failure(error))
            }
        }
        
        // ViewController의 input.tvTrigger 바인딩
//        input.tvTrigger.bind {
//            print("tvTrigger")
//        }.disposed(by: disposeBag)
        
//        input.MovieTrigger.bind {
//            print("movieTrigger")
//        }.disposed(by: disposeBag)
        
        return Output(tvList: tvList, movieResult: movieResult)
    }
}
