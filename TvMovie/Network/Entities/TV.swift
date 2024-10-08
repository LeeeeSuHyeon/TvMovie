//
//  TV.swift
//  TvMovie
//
//  Created by 이수현 on 7/30/24.
//

import Foundation

struct TVListModel : Decodable {
    let page : Int
    let results : [TV]
}

struct TV : Decodable, Hashable {
    let id : Int
    let name : String
    let overview : String
    let posterURL : String
    let vote : String
    let firstAirDate : String
    
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        
        let path = try container.decodeIfPresent(String.self, forKey: .posterPath)
        if let path = path {
            posterURL = APIIMAGEPATH + path
        } else {
            posterURL = ""
        }
        let voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        let voteCount = try container.decode(Int.self, forKey: .voteCount)
        vote = "\(voteAverage) (\(voteCount))"
        firstAirDate = try container.decode(String.self, forKey: .firstAirDate)
    }
    
}

//https://api.themoviedb.org/3/tv/top_rated?api_key=a2b4f31ac5d507b646da97dd148418b2&language=kr


//{
//"page": 1,
//"results": [],
//"total_pages": 45325,
//"total_results": 906498
//}


//{
//  "page": 1,
//  "results": [
//    {
//      "adult": false,
//      "backdrop_path": "/96RT2A47UdzWlUfvIERFyBsLhL2.jpg",
//      "genre_ids": [16, 18, 10759, 10765],
//      "id": 209867,
//      "origin_country": [
//        "JP"
//      ],
//      "original_language": "ja",
//      "original_name": "葬送のフリーレン",
//      "overview": "",
//      "popularity": 272.968,
//      "poster_path": "/dDRiOkCBCkd7w6ysMFr39G16opQ.jpg",
//      "first_air_date": "2023-09-29",
//      "name": "葬送のフリーレン",
//      "vote_average": 8.9,
//      "vote_count": 237
//    },
//    {
//      "adult": false,
//      "backdrop_path": "/9kyyQXy79YRdY5mhrYKyktbFMev.jpg",
//      "genre_ids": [16, 35, 10765],
//      "id": 94954,
//      "origin_country": [
//        "US"
//      ],
//      "original_language": "en",
//      "original_name": "Hazbin Hotel",
//      "overview": "",
//      "popularity": 216.526,
//      "poster_path": "/rXojaQcxVUubPLSrFV8PD4xdjrs.jpg",
//      "first_air_date": "2024-01-18",
//      "name": "Hazbin Hotel",
//      "vote_average": 8.932,
//      "vote_count": 1017
//    },
