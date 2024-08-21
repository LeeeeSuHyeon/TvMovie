//
//  Review.swift
//  TvMovie
//
//  Created by 이수현 on 8/21/24.
//

import Foundation

struct ReviewListModel : Decodable {
    let page : Int
    let results : [ReviewModel]
}

struct ReviewModel : Decodable, Hashable {
    let id : String
    let author : Reviewer
    let createdDate : Date?
    let content : String

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case createdDate = "created_at"
        case content
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.author = try container.decode(Reviewer.self, forKey: .author)
        let dateString = try container.decode(String.self, forKey: .createdDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        createdDate = dateFormatter.date(from: dateString)
        
        self.content = try container.decode(String.self, forKey: .content)
    }
}

struct Reviewer : Decodable, Hashable {
    let name : String
    let username : String
    let rating : Int
    let imagePath : String
    
    enum CodingKeys : String, CodingKey {
        case name
        case username
        case imagePath = "avatar_path"
        case rating
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        rating = try container.decode(Int.self, forKey: .rating)
        let path = try container.decode(String.self, forKey: .imagePath)
        imagePath = APIIMAGEPATH + path
    }
}


// https://developer.themoviedb.org/reference/review-details
