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
    
    struct Input {
        let tvTrigger : Observable<Void>
        let MovieTrigger : Observable<Void>
    }
    
    struct Output {
        let tvList : Observable<[TV]>
//        let MovieList : Observable<MovieResult>
    }
    
    func transform(input : Input) -> Output {
        
        // ViewController의 input.tvTrigger 바인딩
        input.tvTrigger.bind {
            print("tvTrigger")
        }.disposed(by: disposeBag)
        
        return Output(tvList: Observable<[TV]>.just([]))
    }
}
