//
//  TVNetwork.swift
//  TvMovie
//
//  Created by 이수현 on 7/31/24.
//

import Foundation
import RxSwift

final class TVNetwork {
    private let network : Network<TVListModel>
    
    init(network: Network<TVListModel>) {
        self.network = network
    }
    
    func getTopRatedList(page : Int) -> Observable<TVListModel>{
        return network.getItemList(path: "tv/top_rated", page : page)
    }
    
    func getQueriedList(page : Int, query : String) -> Observable<TVListModel>{
        return network.getItemList(path: "search/tv", page: page, query : query)
    }
}

// https://developer.themoviedb.org/reference/search-tv
//https://api.themoviedb.org/3/search/tv
