//
//  ReviewViewModel.swift
//  TvMovie
//
//  Created by 이수현 on 8/23/24.
//

import Foundation
import UIKit
import RxSwift

final class ReviewViewModel {
    let id : Int
    let contentType : ContentType
    let reviewNetwork : ReviewNetwork
    
    init(id : Int, contentType : ContentType){
        self.id = id
        self.contentType = contentType
        
        let networkProvider = NetworkProvider()
        reviewNetwork = networkProvider.makeReviewNetwork()
    }
    
    struct Input {
        
    }
    
    struct Output {
        let reviewResult : Observable<Result<[ReviewModel], Error>>
    }
    
    func transform(input : Input) -> Output{
        let reviewResult : Observable<Result<[ReviewModel], Error>> = reviewNetwork.getReviewList(id: id, contentType: contentType).map { reviewResult in
            return .success(reviewResult.results)
        }.catchError { error in
            return Observable.just(.failure(error))
        }
        
        return Output(reviewResult: reviewResult)
    }
}
