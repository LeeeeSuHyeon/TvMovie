//
//  ReviewViewController.swift
//  TvMovie
//
//  Created by 이수현 on 8/21/24.
//

import Foundation
import UIKit

class ReviewViewController : UIViewController {
    init(id : Int, contentType : ContentType){
        super.init(nibName: nil, bundle: nil)
        print("ReviewViewController :  \(id), \(contentType)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
