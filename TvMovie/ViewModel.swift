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
    
    init(){
        let provider = NetworkProvider()
        tvNetwork = provider.makeTVNetwork()
        movieNetwork = provider.makeMovieNetwork()
    }
    
    struct Input {
        let tvTrigger : Observable<Void>
        let MovieTrigger : Observable<Void>
    }
    
    struct Output {
        let tvList : Observable<[TV]>
        let movieResult : Observable<MovieResult>
    }
    
    func transform(input : Input) -> Output {
        
        // trigger -> network -> Observable<T> -> VC 전달 -> VC 구독
        let tvList = input.tvTrigger.flatMapLatest { [unowned self] _ -> Observable<[TV]> in
            
            // tvTrigger -> Observable<Void> -> Observable<TV>
            return self.tvNetwork.getTopRatedList().map{$0.results}
        }
        
        let movieResult = input.MovieTrigger.flatMapLatest { [unowned self] _ -> Observable<MovieResult> in
            
            // 여러 개의 Observable을 합칠 때는 combineLatest를 사용
            return Observable.combineLatest(movieNetwork.getUpcomming(), movieNetwork.getPopular(), movieNetwork.getNowPlaying()){ upcomming, popular, nowPlaying -> MovieResult in
                
                return MovieResult(upcomming: upcomming, popular: popular, nowPlaying: nowPlaying)
            }
        }
        
        // ViewController의 input.tvTrigger 바인딩
//        input.tvTrigger.bind {
//            print("tvTrigger")
//        }.disposed(by: disposeBag)
        
        input.MovieTrigger.bind {
            print("movieTrigger")
        }.disposed(by: disposeBag)
        
        return Output(tvList: tvList, movieResult: movieResult)
    }
}
