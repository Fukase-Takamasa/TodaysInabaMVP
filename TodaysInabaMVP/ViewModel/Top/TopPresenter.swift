//
//  TopPresenter.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation

protocol TopPresenterInterface: AnyObject {
    func successResponse(data: GoogleData)
    func errorResponse()
}

final class TopPresenter {
    
    private weak var listener: TopPresenterInterface?
    
    init(listener: TopPresenterInterface) {
        self.listener = listener
    }
    
    func requestAPI() {
        
        APIModel.getTodaysInabaImages(callBack: { (response, error) in
            
            if let response = response {
                self.listener?.successResponse(data: response)
            }else {
                self.listener?.errorResponse()
            }
            
        })
        
    }
    
}
