//
//  Movie.swift
//  TvMovie
//
//  Created by 이수현 on 7/30/24.
//

import Foundation

struct MovieListModel : Decodable {
    let page : Int
    let results : [Movie]
}

struct Movie : Decodable {
    let title : String
    let overview : String
    let posterPath : String
    let vote : String
    let releaseDate : String
    
    private enum CodingKeys : String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average" 
        case voteCount = "vote_count"
        case releaseDate = "release_date"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        
        let path = try container.decode(String.self, forKey: .posterPath)
        posterPath = APIIMAGEPATH + path
        
        let voteAverage = try container.decode(String.self, forKey: .voteAverage)
        let voteCount = try container.decode(String.self, forKey: .voteCount)
        vote = "\(voteAverage) (\(voteCount))"
        
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}


//https://api.themoviedb.org/3/movie/popular?api_key=a2b4f31ac5d507b646da97dd148418b2&language=kr

//{
//  "page": 1,
//  "results": [
//    {
//      "adult": false,
//      "backdrop_path": "/9l1eZiJHmhr5jIlthMdJN5WYoff.jpg",
//      "genre_ids": [28, 35, 878],
//      "id": 533535,
//      "original_language": "en",
//      "original_title": "Deadpool & Wolverine",
//      "overview": "",
//      "popularity": 7220.83,
//      "poster_path": "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
//      "release_date": "2024-07-24",
//      "title": "Deadpool & Wolverine",
//      "video": false,
//      "vote_average": 8.079,
//      "vote_count": 777
//    },
//    {
//      "adult": false,
//      "backdrop_path": "/tncbMvfV0V07UZozXdBEq4Wu9HH.jpg",
//      "genre_ids": [28, 80, 53, 35],
//      "id": 573435,
//      "original_language": "en",
//      "original_title": "Bad Boys: Ride or Die",
//      "overview": "",
//      "popularity": 7285.79,
//      "poster_path": "/nP6RliHjxsz4irTKsxe8FRhKZYl.jpg",
//      "release_date": "2024-06-05",
//      "title": "Bad Boys: Ride or Die",
//      "video": false,
//      "vote_average": 7.656,
//      "vote_count": 1120
//    },
