//
//  APIModel.swift
//  TodaysInabaMVVM
//
//  Created by 深瀬 貴将 on 2020/10/08.
//

import Foundation
import Moya

final class APIModel {
    
    private static let provider = MoyaProvider<API>()
    
    static func getTodaysInabaImages(callBack: @escaping (GoogleData?, MoyaError?) -> Void) {
        provider.request(
            .CustomSearch(
                query: "稲葉浩志" + ["かっこいい", "かわいい", "眼鏡", "へそ", "97年"].randomElement()!,
                startIndex: Int.random(in: 1...10)))
        { result in
            switch result {
            case let .success(moyaResponse):
                let googleData = try! JSONDecoder().decode(GoogleData.self, from: moyaResponse.data)
                callBack(googleData, nil)
                
            case let .failure(error):
                print(error.localizedDescription)
                
                callBack(nil, error)
            }
        }
    }
    
    static func success() {
        
    }
    
}
