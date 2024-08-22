//
//  ReviewNetwork.swift
//  TvMovie
//
//  Created by 이수현 on 8/22/24.
//

import Foundation
import RxSwift

final class ReviewNetwork {
    private let network : Network<ReviewListModel>
    
    init(network: Network<ReviewListModel>) {
        self.network = network
    }
    
    func getReviewList(id : String, contentType : ContentType) -> Observable<ReviewListModel> {
        return network.getItemList(path: "\(contentType.rawValue)/\(id)/reviews", language: "en")
    }
}
