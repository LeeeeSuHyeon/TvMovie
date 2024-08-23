//
//  ReviewViewController.swift
//  TvMovie
//
//  Created by 이수현 on 8/21/24.
//

import Foundation
import UIKit
import RxSwift

class ReviewViewController : UIViewController {
    let reviewViewModel : ReviewViewModel
    let disposeBag = DisposeBag()
    
    init(id : Int, contentType : ContentType){
        self.reviewViewModel = ReviewViewModel(id: id, contentType: contentType)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    func bindViewModel(){
        let output = reviewViewModel.transform(input: ReviewViewModel.Input())
        output.reviewResult.bind { result in
            switch result {
            case .success(let reviewList) :
                print(reviewList)
            case .failure(let error) :
                print(error)
                
            }
            
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
