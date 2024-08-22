//
//  Content.swift
//  TvMovie
//
//  Created by 이수현 on 8/12/24.
//

import Foundation

enum ContentType : String, Decodable {
    case tv
    case movie
}


// TV, Movie를 같이 사용하기 위한 모델
struct Content : Decodable, Hashable{
    let id : Int
    let title : String
    let overview : String
    let posterPath : String
    let vote : String
    let releaseDate : String
    let type : ContentType
    
    init(tv : TV){
        id = tv.id
        title = tv.name
        overview = tv.overview
        posterPath = tv.posterURL
        vote = tv.vote
        releaseDate = tv.firstAirDate
        type = .tv
    }
    
    init(movie : Movie){
        id = movie.id
        title = movie.title
        overview = movie.overview
        posterPath = movie.posterPath
        vote = movie.vote
        releaseDate = movie.releaseDate
        type = .movie
    }
}
