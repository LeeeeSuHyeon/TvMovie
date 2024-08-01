//
//  ViewModel.swift
//  TvMovie
//
//  Created by 이수현 on 8/1/24.
//

import Foundation
import RxSwift

class ViewModel {
    
    struct Input {
        let tvTrigger : Observable<Void>
        let MovieTrigger : Observable<Void>
    }
    
    struct Output {
        let tvList : Observable<[TV]>
//        let MovieList : Observable<MovieResult>
    }
    
    func transform(input : Input) -> Output {
        return Output(tvList: Observable<[TV]>.just([]))
    }
}
