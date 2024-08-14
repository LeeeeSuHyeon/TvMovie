//
//  MovieNetwork.swift
//  TvMovie
//
//  Created by 이수현 on 7/31/24.
//

import Foundation
import RxSwift

final class MovieNetwork {
    let network : Network<MovieListModel>
    
    init(network: Network<MovieListModel>) {
        self.network = network
    }
    
    func getPopular() -> Observable<MovieListModel>{
        return network.getItemList(path: "movie/popular")
    }
    
    func getUpcoming() -> Observable<MovieListModel>{
        return network.getItemList(path: "movie/upcoming")
    }
    
    func getNowPlaying() -> Observable<MovieListModel>{
        return network.getItemList(path: "movie/now_playing")
    }
}
