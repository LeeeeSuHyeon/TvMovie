//
//  NetworkProvider.swift
//  TvMovie
//
//  Created by 이수현 on 7/31/24.
//

import Foundation

final class NetworkProvider {
    private let endPoint : String
    
    init() {
        self.endPoint = "https://api.themoviedb.org/3/"
    }
    
    func makeTVNetwork() -> TVNetwork {
        let network = Network<TVListModel>(endPoint: endPoint)
        return TVNetwork(network: network)
    }
    
    func makeMovieNetwork() -> MovieNetwork {
        let network = Network<MovieListModel>(endPoint: endPoint)
        return MovieNetwork(network: network)
    }
    
}
