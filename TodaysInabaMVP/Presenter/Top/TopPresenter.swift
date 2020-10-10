//
//  TopPresenter.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation

protocol TopPresenterInterface: AnyObject {
    func successResponse(url: String)
    func errorResponse(error: Error)
}

final class TopPresenter {
    
    private weak var listener: TopPresenterInterface?
    
    init(listener: TopPresenterInterface) {
        self.listener = listener
    }
    
    func requestAPI() {
        
        APIModel.getTodaysInabaUrl(callBack: { (response, error) in
            
            if let response = response {
                self.listener?.successResponse(url: response)
                //UDに保存
                UserDefaultsModel.saveUrl(value: response)
                
            }else if let error = error {
                self.listener?.errorResponse(error: error)
                print("moyaError: \(error)")
                error
            }else {
                print("responseとerror両方ともnil")
            }
            
        })
        
    }
    
}
