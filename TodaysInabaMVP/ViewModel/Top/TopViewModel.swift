//
//  TopViewModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation
import RxSwift
import RxCocoa

class TopViewModel {
    
    //input
    let userName: AnyObserver<String>
    
    //output
    let todaysInabaResponse: Observable<GoogleData>
    let isFetching: Observable<Bool>
    
    init() {
        let disposeBag = DisposeBag()
        
        //output
        let _todaysInabaResponse = PublishRelay<GoogleData>()
        self.todaysInabaResponse = _todaysInabaResponse.asObservable()
        
        let _isFetching = PublishRelay<Bool>()
        self.isFetching = _isFetching.asObservable()
        
        //input
        self.userName = AnyObserver<String>() { event in
            guard let text = event.element else {return}
            guard !text.isEmpty else {return}
            
            _isFetching.accept(true)
            
            APIModel.getTodaysInabaImages()
                .subscribe(onNext: { element in
                    _isFetching.accept(false)
                    _todaysInabaResponse.accept(element)
                }).disposed(by: disposeBag)
        }
    }
}
