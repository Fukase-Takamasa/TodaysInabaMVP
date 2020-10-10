//
//  ResultViewModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/09.
//

import Foundation
import RxSwift
import RxCocoa

class ResultViewModel {
    
    //input
    
    //output
    let resultImageUrl: String?
    
    init(resultImageUrl: String?) {
        let disposeBag = DisposeBag()
        
        //output
        self.resultImageUrl = resultImageUrl
        
        //input
    }
}
