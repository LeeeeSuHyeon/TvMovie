//
//  Network.swift
//  TvMovie
//
//  Created by 이수현 on 7/30/24.
//

import Foundation
import RxSwift
import RxAlamofire


class Network<T : Decodable> {
    private let endPoint : String
    private let queue : ConcurrentDispatchQueueScheduler
    
    init(endPoint: String) {
        self.endPoint = endPoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func getItemList(path : String, language : String = "ko") -> Observable<T> {

        let fullPath = "\(endPoint)\(path)?api_key=\(APIKEY)&language=\(language)"
        print("getItemList - path : \(fullPath)")
        return RxAlamofire.data(.get, fullPath)
            .observeOn(queue)
            .debug()
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
